import React from 'react'
import ReactDOM from 'react-dom'

import { Form, TextArea } from 'semantic-ui-react'

// TODO
const Avatar = () => (
  <img src="https://avatars.githubusercontent.com/u/1477555?v=4" />
)

const CreatePost = () => (
  <Form>
    <Avatar />
    <TextArea placeholder="What's happening?"/>
  </Form>
)

export default CreatePost
