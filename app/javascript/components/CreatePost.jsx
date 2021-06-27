import React, { useState } from 'react'
import ReactDOM from 'react-dom'

import axios from 'utils/axios'
import { css } from '@emotion/styled'

import {
  Button,
  Form,
  TextArea
} from 'semantic-ui-react'

import Avatar from 'components/Avatar'

// TODO: character limit
// TODO: on hit enter submit
// TODO: async submit, then display as post
const CreatePost = () => {
  const [text, setText] = useState('')
  const doSubmit = (e) => {
    e.preventDefault()
    axios.post('/posts', { content: text }).then(
      // TODO: update store
    )
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
