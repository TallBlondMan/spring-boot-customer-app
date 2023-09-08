import axios from 'axios'

export default axios.create({
    baseURL: process.env.API_BASE_URL || "http://localhost:8080/api",
    headers: {
        'Content-Type': 'application/json'
    }
})