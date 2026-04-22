import { useEffect, useState } from 'react'
import './App.css'

function App() {
  const [message, setMessage] = useState('Chargement...')
  const [status, setStatus] = useState('')

  useEffect(() => {
    fetch(`${import.meta.env.VITE_API_URL}/api/message`)
      .then((response) => response.json())
      .then((data) => {
        setMessage(data.message)
        setStatus(data.status)
      })
      .catch(() => {
        setMessage('Erreur de connexion au backend')
        setStatus('error')
      })
  }, [])

  return (
    <div className="App">
      <h1>Frontend React</h1>
      <p>Message du backend :</p>
      <h2>{message}</h2>
      <p>Statut : {status}</p>
    </div>
  )
}

export default App
