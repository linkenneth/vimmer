/**
 * axios but with app-specific configuration
 */

import axios from 'axios'

const csrfToken = document.querySelector("meta[name=csrf-token]").content
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

export default axios
