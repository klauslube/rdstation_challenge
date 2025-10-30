# Desafio técnico e-commerce RD-STATION

API RESTful para gerenciamento de carrinho de compras desenvolvida em Ruby on Rails.

## 📋 Descrição

Sistema de carrinho de compras que permite adicionar produtos, gerenciar quantidades e processar carrinhos abandonados automaticamente.

## 🚀 Funcionalidades

- ✅ Criar e gerenciar carrinho de compras
- ✅ Adicionar produtos ao carrinho
- ✅ Atualizar quantidades de produtos
- ✅ Remover produtos do carrinho
- ✅ Calcular total do carrinho automaticamente
- ✅ Marcar carrinhos inativos como abandonados (após 3 horas)
- ✅ Remover carrinhos abandonados antigos (após 7 dias)
- ✅ Processamento assíncrono com Sidekiq

## 🛠 Tecnologias

- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15


## 💻 Instalação
```bash
# Clone o repositório
git clone 
cd rdstation_challenge

# Instale as dependências
bundle install

# Configure o banco de dados
rails db:create db:migrate

# Popule o banco (se necessário)
rails db:seed

# Inicie o Redis
redis-server

# Em um terminal, inicie o Rails
bundle exec rails server

# Em outro terminal, inicie o Sidekiq
bundle exec sidekiq

# Rode os testes
bundle exec rspec
```

## 🔌 Endpoints da API

### 1. Adicionar produto ao carrinho

**POST /cart**

Adiciona um produto ao carrinho da sessão atual e retorna a lista de produtos do carrinho.

**Request:**
```json
{
  "product_id": 345,
  "quantity": 2
}
```

**Response:** `201 Created`
```json
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 7.96
}
```

### 2. Listar itens do carrinho

**GET /cart**

Retorna os produtos no carrinho atual da sessão.

**Response:** `200 OK`
```json
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 7.96
}
```

### 3. Incrementar quantidade de produto

**POST /cart/add_items**

Incrementa a quantidade de um produto já existente no carrinho. Se o produto não existir, adiciona com a quantidade especificada.

**Request:**
```json
{
  "product_id": 1230,
  "quantity": 1
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "products": [
    {
      "id": 1230,
      "name": "Nome do produto X",
      "quantity": 2,
      "unit_price": 7.00,
      "total_price": 14.00
    },
    {
      "id": 1020,
      "name": "Nome do produto Y",
      "quantity": 1,
      "unit_price": 9.90,
      "total_price": 9.90
    }
  ],
  "total_price": 23.90
}
```

### 4. Remover produto do carrinho

**DELETE /cart/:product_id**

Remove um produto específico do carrinho.

**Response:** `200 OK`
```json
{
  "id": 789,
  "products": [],
  "total_price": 0.0
}
```

**Erros possíveis:**
- `404 Not Found` - Carrinho não encontrado
- `404 Not Found` - Produto não encontrado no carrinho

## 🤖 Background Jobs

### AbandonCartJob

Job executado para processar carrinhos abandonados:
1. Marcar carrinhos inativos (>3h sem interação) como abandonados
2. Remover carrinhos abandonados há mais de 7 dias

### Executar manualmente
```bash
# Execute o rake task para processar carrinhos
rails cart:abandon
```

### Testar o Job via console
```bash
# Inicie o console do Rails
rails console
```
```ruby
# Cria carrinhos de teste
Cart.create!(status: :active, last_interaction_at: 4.hours.ago, total_price: 0)
Cart.create!(status: :abandoned, abandoned_at: 10.days.ago, last_interaction_at: 12.days.ago, total_price: 0)

# Enfileira o job
AbandonCartJob.perform_later

# Aguarde alguns segundos e verifique os resultados
Cart.all.pluck(:id, :status, :abandoned_at)

# Resultado esperado:
# - Carrinho ativo antigo foi marcado como abandoned
# - Carrinho abandonado antigo foi removido
```

## 🧪 Testes
```bash
# Rodar todos os testes
bundle exec rspec

# Rodar testes específicos
bundle exec rspec spec/models/cart_spec.rb
bundle exec rspec spec/requests/carts_spec.rb
bundle exec rspec spec/jobs/abandon_cart_job_spec.rb

# Com cobertura
bundle exec rspec --format documentation
```

## 📊 Modelos

### Cart
- `status` (enum): `active` ou `abandoned`
- `total_price` (decimal): Total do carrinho
- `last_interaction_at` (datetime): Última interação do usuário
- `abandoned_at` (datetime): Quando foi marcado como abandonado

### Product
- `name` (string): Nome do produto
- `price` (decimal): Preço unitário

### CartItem
- `cart_id` (integer): Referência ao carrinho
- `product_id` (integer): Referência ao produto
- `quantity` (integer): Quantidade do produto

## 🔄 Regras de Negócio

1. **Carrinho por Sessão**: Cada sessão tem seu próprio carrinho
2. **Abandono Automático**: Carrinhos inativos por 3+ horas são marcados como abandonados
3. **Limpeza Automática**: Carrinhos abandonados há 7+ dias são removidos
4. **Cálculo Automático**: O total do carrinho é calculado automaticamente via callbacks


## 📄 Licença

Este projeto foi desenvolvido como parte de um desafio técnico.

## 👤 Autor

Klaus Lube

---

**Nota**: Este projeto foi desenvolvido como parte do desafio técnico da RD Station.