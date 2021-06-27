import React, { useState } from 'react'
import ReactDOM from 'react-dom'

import axios from 'utils/axios'
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
const CreatePost = () => {
  const [text, setText] = useState('')
  const doSubmit = (e) => {
    e.preventDefault()
    axios.post('/posts', { content: text })
  }

  return (
    <Form css={{ display: 'flex' }}>
      <Avatar src="https://avatars.githubusercontent.com/u/1477555?v=4" />
     <TextArea
       placeholder="What's happening?"
       onInput={(e, data) => setText(data.value)}
       value={text}
     />
      <Button
        primary
        onClick={doSubmit}>
        Tweet
      </Button>
    </Form>
  )
}

export default CreatePost
