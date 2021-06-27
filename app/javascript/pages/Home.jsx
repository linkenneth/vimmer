import React from 'react'
import ReactDOM from 'react-dom'

import CreatePost from 'components/CreatePost'

const LeftNav = () => (
  <aside>
    <ul>
      <li>Home</li>
      <li>Home</li>
    </ul>
  </aside>
)

// TODO
const Feed = () => ();

const CenterFeed = () => (
  <main>
    <CreatePost />
    <Feed />
  </main>
)

const Home = () => (
  <div>
    <LeftNav />
    <CenterFeed />
  </div>
)

export default Home
