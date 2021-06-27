import React, { useState } from 'react'
import ReactDOM from 'react-dom'

import axios from 'utils/axios'
import { css } from '@emotion/react'

import { Dimmer, Loader } from 'semantic-ui-react'

import CreatePost from 'components/CreatePost'
import Feed from 'components/Feed'

const CenterFeed = ({ posts }) => {
  return (
    <main css={css`
      margin: 16px;
    `}>
      <CreatePost />
      <Feed posts={posts}/>
    </main>
  )
}

const Home = () => {
  const [loading, setLoading] = useState(true)
  const [posts, setPosts] = useState([])

  if (posts.length === 0) {
    axios.get('/posts').then(resp => {
      setPosts(resp.data)
      setLoading(false)
    })
  }

  if (loading) {
    return (
      <Dimmer active>
        <Loader>Loading</Loader>
      </Dimmer>
    )
  }

  return (
    <div>
      <CenterFeed posts={posts} />
    </div>
  )
}

export default Home
