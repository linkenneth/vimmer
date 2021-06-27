# frozen_string_literal: true

# NOTE to john: I wrote this module at my current compnay, so copied and pasted
# it over for easy use.

module SqlUtils
  ##
  # Returns the union of a number of relations.
  #
  # @example
  #
  #   SqlUtils.union(
  #     Candidate.where(accepted_at: nil),
  #     Candidate.where(id: 3)
  #   ).to_sql
  #
  # produces
  #
  #   SELECT "candidates".* FROM (
  #     SELECT "candidates".* FROM "candidates" WHERE "candidates"."accepted_at" IS NULL
  #     UNION
  #     SELECT "candidates".* FROM "candidates" WHERE "candidates"."id" = 3
  #   ) as "candidates"
  #
  # @see https://www.postgresql.org/docs/current/queries-union.html

  def self.union(*relations)
    raise ::ArgumentError, 'at least one relation required' unless relations.size >= 1
    unless relations.all? { |relation| relation.respond_to?(:to_sql) }
      raise ::ArgumentError, 'arguments must be relation that responds to #to_sql'
    end

    sql = relations.map { |r| "(#{r.to_sql})" }.join(' UNION ')
    model = relations.first.klass
    table_name = ActiveRecord::Base.connection.quote_table_name(model.table_name)
    model.unscoped.from("(#{sql}) AS #{table_name}")
  end

  ##
  # Returns the intersection of a number of relations.
  #
  # @example
  #
  #   SqlUtils.intersect(
  #     Candidate.where(accepted_at: nil),
  #     Candidate.where(id: 3)
  #   ).to_sql
  #
  # produces
  #
  #   SELECT "candidates".* FROM (
  #     SELECT "candidates".* FROM "candidates" WHERE "candidates"."accepted_at" IS NULL
  #     INTERSECT
  #     SELECT "candidates".* FROM "candidates" WHERE "candidates"."id" = 3
  #   ) as "candidates"
  #
  # @see https://www.postgresql.org/docs/current/queries-union.html

  def self.intersect(*relations)
    raise ::ArgumentError, 'at least one relation required' unless relations.size >= 1
    unless relations.all? { |relation| relation.respond_to?(:to_sql) }
      raise ::ArgumentError, 'arguments must be relation that responds to #to_sql'
    end

    sql = relations.map { |r| "(#{r.to_sql})" }.join(' INTERSECT ')
    model = relations.first.klass
    table_name = ActiveRecord::Base.connection.quote_table_name(model.table_name)
    model.unscoped.from("(#{sql}) AS #{table_name}")
  end

  ##
  # Returns the set difference of a number of relations from the first relation.
  #
  # @example
  #
  #   SqlUtils.except(
  #     Candidate.where(accepted_at: nil),
  #     Candidate.where(id: 3)
  #   ).to_sql
  #
  # produces
  #
  #   SELECT "candidates".* FROM (
  #     SELECT "candidates".* FROM "candidates" WHERE "candidates"."accepted_at" IS NULL
  #     EXCEPT
  #     SELECT "candidates".* FROM "candidates" WHERE "candidates"."id" = 3
  #   ) as "candidates"
  #
  # @see https://www.postgresql.org/docs/current/queries-union.html

  def self.except(*relations)
    raise ::ArgumentError, 'at least one relation required' unless relations.size >= 1
    unless relations.all? { |relation| relation.respond_to?(:to_sql) }
      raise ::ArgumentError, 'arguments must be relation that responds to #to_sql'
    end

    sql = relations.map { |r| "(#{r.to_sql})" }.join(' EXCEPT ')
    model = relations.first.klass
    table_name = ActiveRecord::Base.connection.quote_table_name(model.table_name)
    model.unscoped.from("(#{sql}) AS #{table_name}")
  end

  ##
  # Returns a sampling of a relation.
  #
  # This is a higher-level method than `.tablesample` below. Instead of
  # understanding the intricacies around not biasing the distribution by
  # forgetting `.random_order` after your `.tablesample`, you can simply specify
  # whether you want a count, a percent, and whether you strictly care about the
  # biasing the distribution or not.
  #
  # When specifying a count, an exact number of rows is always returned. This is
  # done through using a count estimate by parsing Postgres EXPLAIN output,
  # which may or may not be accurate (it tends to get less accurate with more
  # complicated queries).
  #
  # If you provide both a percent and a count, `.sample` will use the percent
  # provided as a baseline TABLESAMPLE percentage to check, skipping the
  # count estimation step.
  #
  # @param percent The sample percentage to use. When both `percent` and `count`
  # is specified, `percent` is used as a "baseline" percentage to use with
  # TABLESAMPLE so that the we can skip some count estimation queries.
  # @param count The number of samples to select.
  # @param fast  Whether to disregard biasing the distribution and sample as
  # fast as possible.
  #
  # @example
  #
  # Simple usage:
  #   SqlUtils.sample(Candidate.all, count: 1)
  #
  # When you know roughly the size of the underlying query, you can save on
  # some count estimation pre-queries:
  #   SqlUtils.sample(Candidate.all, count: 100, percent: 0.001)
  #
  # When you want to ensure randomness of distribution, but care less about
  # speed:
  #   SqlUtils.sample(Candidate.all, percent: 0.1, fast: false)

  def self.sample(relation, percent: nil, count: nil, fast: true, seed: nil)
    if percent.nil? && count.nil?
      raise ::ArgumentError, 'must provide at least one of `percent` or `count`'
    end

    seed ||= rand
    sampler = if fast
                lambda { tablesample(relation, system: percent, repeatable: seed) }
              else
                lambda { tablesample(relation, bernoulli: percent, repeatable: seed).random_order }
              end

    # if no count is specified, directly return tablesample with correct distro
    return sampler.call unless count

    # otherwise, perform exponential searching. Initialize first guess at
    # around 5x the EXPLAIN table size estimate.
    percent ||= 5 * count.to_f / count_estimate(relation) * 100

    loop do
      return relation.limit(count) if percent >= 100

      actual_count = sampler.call.count
      if actual_count >= count
        return sampler.call.limit(count)
      else
        # we under-estimated. If we have some notion of how much we
        # underestimated, improve our estimate by 2x that just in case.
        # Otherwise, 10x our estimate.
        multiplier = actual_count > 0 ? [2 * count / actual_count, 5].min : 10
        percent *= multiplier
      end
    end
  end

  ##
  # Returns an estimated count of a relation.
  #
  # This estimation is generated from running EXPLAIN (without ANALYZE) on the
  # query, and tallying up all the rows. For more details, see the referenced
  # article.
  #
  # @see https://wiki.postgresql.org/wiki/Count_estimate

  def self.count_estimate(relation)
    sql = ActiveRecord::Base.connection.quote_string(relation.to_sql)
    result = ActiveRecord::Base.connection.execute(<<~SQL.squish)
      DROP TABLE IF EXISTS _count_estimates;
      CREATE TEMPORARY TABLE _count_estimates (ROWS INTEGER) ON COMMIT DROP;

      DO $func$
      DECLARE
          query text := '#{sql}';
          rec   record;
          ROWS  INTEGER;
      BEGIN
          FOR rec IN EXECUTE 'EXPLAIN ' || query LOOP
              ROWS := SUBSTRING(rec."QUERY PLAN" FROM ' rows=([[:digit:]]+)');
              EXIT WHEN ROWS IS NOT NULL;
          END LOOP;

          EXECUTE 'INSERT INTO _count_estimates SELECT $1' USING ROWS;
      END
      $func$ LANGUAGE plpgsql;

      SELECT * FROM _count_estimates;
    SQL
    result.values.first.first
  end

  ##
  # Returns a sampling of a relation, using Postgres TABLESAMPLE.
  #
  # This method is useful as an alternative to `.random_order.first`, which
  # contrary to expectations, sorts the entire table only take the first row.
  #
  # If you use this method, you should be careful using this with `.limit`, and
  # understand its implications on the distribution of rows.
  # https://dba.stackexchange.com/questions/259144 explains this pretty well,
  # and https://bit.ly/37jGO6T also shows the differences in distributions when
  # using `.random_order`. To avoid distorting the distribution, you should
  # combine this method with `.random_order` as in the example below.
  #
  # Alternatively, consider using `.sample` above, which is a higher-level
  # method.
  #
  # @see https://wiki.postgresql.org/wiki/TABLESAMPLE_Implementation
  # @see https://dba.stackexchange.com/questions/259144
  # @param bernoulli The sample percentage using a Bernoulli distribution,
  # created by sampling individual rows in the database. This is slower but
  # gives a better random distribution. Defaults to BERNOULLI (10).
  # @param system The sample percentage using an approximation, created by
  # sampling each physical page in the database. This is faster but there are
  # not as random.
  # @param repeatable A seed with which to generate repeatable results.
  #
  # @example
  #
  #   SqlUtils.tablesample(
  #     Candidate.ever_did_quiz, bernoulli: 1
  #   ).random_order.limit(100)
  #
  # produces
  #
  #   SELECT "candidates".* FROM "candidates"
  #   TABLESAMPLE BERNOULLI (1)
  #   WHERE (("candidates"."step_flags" & 536870912 = 536870912))
  #   ORDER BY RANDOM()
  #   LIMIT 100

  def self.tablesample(relation, bernoulli: nil, system: nil, repeatable: nil)
    raise ::ArgumentError, 'relation must respond to #to_sql' unless relation.respond_to?(:to_sql)
    if bernoulli && system
      raise ::ArgumentError, 'cannot use both BERNOULLI and SYSTEM distributions'
    elsif !bernoulli && !system
      bernoulli = 10
    end

    table_name = ActiveRecord::Base.connection.quote_table_name(relation.klass.table_name)

    sql = "#{table_name} TABLESAMPLE"
    sql += " BERNOULLI (#{bernoulli.to_f})" if bernoulli
    sql += " SYSTEM (#{system.to_f})" if system
    sql += " REPEATABLE (#{repeatable.to_f})" if repeatable

    relation.from(sql)
  end
end
