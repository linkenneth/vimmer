import React from 'react'
import ReactDOM from 'react-dom'

const Login = () => (
  <main>
    <h1>Login</h1>
    <label htmlFor='email'>Email:</label>
    <input id='email' type='text' placeholder='john@vimcal.com' />
    <label htmlFor='password'>Password:</label>
    <input id='password' type='password' placeholder='hunter11' />
    <button>Submit</button>
  </main>
)

export default Login
