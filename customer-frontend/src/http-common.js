import axios from 'axios'

export default axios.create({
    baseURL: "http://10.6.0.232:8080/api",
    headers: {
        'Content-Type': 'application/json'
    }
})