import React, { useState } from 'react'
import ReactDOM from 'react-dom'

import Post from 'components/Post'

const Feed = ({ posts }) => {
  return (
    <div>
      {posts.map(post => (
        <Post key={post.id} post={post} />
      ))}
    </div>
  )
}

export default Feed
