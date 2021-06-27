import React from 'react'
import ReactDOM from 'react-dom'

import styled, { css } from '@emotion/styled'

import {
  Button,
  Form,
  TextArea
} from 'semantic-ui-react'

// TODO
const Avatar = styled.img`
  border-radius: 100%;
  width: 32px;
  height: 32px;
`

// TODO: character limit
// TODO: on hit enter submit
// TODO: async submit, then display as post
const CreatePost = () => (
  <Form css={{ display: 'flex' }}>
    <Avatar src="https://avatars.githubusercontent.com/u/1477555?v=4" />
    <TextArea placeholder="What's happening?"/>
    <Button primary>Tweet</Button>
  </Form>
)

export default CreatePost
