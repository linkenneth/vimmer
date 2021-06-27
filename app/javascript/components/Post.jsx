import React, { useState } from 'react'
import ReactDOM from 'react-dom'

import { css } from '@emotion/react'

import {
  Button,
  Form,
  TextArea
} from 'semantic-ui-react'

import Avatar from 'components/Avatar'

const Post = ({ post }) => {
  return (
    <div css={css`
      padding: 16px;
      border: gray 1px;
    `}>
      {post.content}
    </div>
  )
}

export default Post
