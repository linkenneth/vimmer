import React from 'react'
import ReactDOM from 'react-dom'

const Login = () => (
  <main>
    <h1>Login</h1>
    <label for='email'>Email:</label>
    <input id='email' type='text' placeholder='john@vimcal.com' />
    <label for='password'>Password:</label>
    <input id='password' type='password' placeholder='hunter11' />
  </main>
)

export default Login
