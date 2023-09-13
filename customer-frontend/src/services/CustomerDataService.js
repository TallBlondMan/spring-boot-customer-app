import http from '../http-common'

class CustomerDataService {
    getAll() {
        return http.get('/api/customers')
    }

    get(id) {
        return http.get(`/api/customers/${id}`)
    }

    create(data) {
        return http.post('/api/customers', data)
    }

    update(id, data) {
        return http.put(`/api/customers/${id}`, data)
    }

    delete(id) {
        return http.delete(`/api/customers/${id}`)
    }
}

export default new CustomerDataService()
