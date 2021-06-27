import React from 'react'
import ReactDOM from 'react-dom'
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link
} from 'react-router-dom'

import Login from 'pages/Login'

const Nav = () => (
  <nav>
    <ul>
      <li>
        <Link to="/">Home</Link>
      </li>
      <li>
        <a href="/users/sign_in">Login</a>
      </li>
    </ul>
  </nav>
)

const Twitter = props => (
  <Router>
    <div>
      <Nav />
      <Switch>
        <Route path="/"> <div>Home</div> </Route>
      </Switch>
    </div>
  </Router>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Twitter />,
    document.body.appendChild(document.createElement('div')),
  )
})
