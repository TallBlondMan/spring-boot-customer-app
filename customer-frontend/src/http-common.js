import axios from 'axios'

export default axios.create({
    baseURL: process.env.VUE_APP_BASE_URL || "http://10.6.0.232:8080/api",
    headers: {
        'Content-Type': 'application/json'
    }
})