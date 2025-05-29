### Banco
- nome: string
- img: string

### Cartao
- nome: string
- icone: Banco
- limite: string
- diaFechamento: string
- diaVencimento: string
- conta: Conta

### Categoria
- nome: string
- cor: color
- icon: IconData

### Conta
- nome: string
- saldo: string
- banco: Banco

### Fatura
- lancamentos: List<Lancamentos>
- cartao: Cartao
- pagamentos: List<Pagamentos>
- data: string
- foiPago: bool

### Pagamento
- valor: string
- data: string

### Gasto
- categoria: Categoria
- valor: string

### Lancamento
- valor: string
- descricao: string
- data: string
- eDespesa: bool
- categoria: Categoria
- conta: Conta
- cartao: Cartao

### Notificacao
- titulo: string
- body: string