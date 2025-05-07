import express from 'express'
import { prisma } from './prisma'

const app = express()
app.use(express.json())

app.get('/users', async (req, res) => {
  const users = await prisma.user.findMany()
  res.json(users)
})

app.post('/users', async (req, res) => {
  const { nome, senha } = req.body
  const user = await prisma.user.create({
    data: { nome, senha },
  })
  res.status(201).json(user)
})

const PORT = 8080
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`)
})