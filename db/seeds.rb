Article.delete_all

user = User.first
text = "A loja da 5 ave é um ponto turístico em si, vale conhecer mesmo que não for comprar nada. Ela é toda de vidro, no formato de cubo e tem uma escada em caracol que foi patenteada pelo Steve Jobs.A visita por lá é imperdível também pela localização, que fica em frente ao The Plaza Hotel tá sempre cheia, então quem quiser fazer compras com calma, existe uma outra Apple Store na Broadway.Horário de Funcionamento."

p 'Iniciando...'

Category.all.each do | category |
  30.times do
    Article.create!(
      title: "Article #{rand(10000)}",
      body: text,
      category_id: category.id,
      user_id: user.id,
      created_at: rand(365).days.ago
    )
  end
end



p 'Terminou!.'