import axios from 'axios'

export default axios.create({
    baseURL: "http://app-backend:8080/api",
    headers: {
        'Content-Type': 'application/json'
    }
})