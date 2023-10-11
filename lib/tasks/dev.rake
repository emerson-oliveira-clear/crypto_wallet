
namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do

    if Rails.env.development?

      show_spinner("Apagando DB..."){%x(rails db:drop)} 
    
      show_spinner("Criando DB..."){%x(rails db:create)}
      
      show_spinner("Migrando DB..."){%x(rails db:migrate)}
      
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
     
      
    else

      puts "voce não está em ambiente de desenvolvimento!"

    end
  end

  #--------------------------------------------------

  desc "Cadastra as moedas"
  task add_coins: :environment do

    show_spinner("Cadastrando moedas no DB...") do
      coins = [
            {
                description: "Lunes",
                acronym: "LUNES",
                url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/3786.png",
                mining_type: MiningType.find_by(acronym: 'PoW')
            },
  
            {   
                description: "Ethereum",
                acronym: "ETH",
                url_image: "https://cryptologos.cc/logos/ethereum-eth-logo.png",
                mining_type: MiningType.all.sample
            },
        
            {   
                description: "Dash Coin",
                acronym: "DASH",
                url_image: "https://cryptologos.cc/logos/dash-dash-logo.png",
                mining_type: MiningType.all.sample
            },
  
            {   
              description: "Bitcoin",
              acronym: "BTC",
              url_image: "https://static.vecteezy.com/system/resources/previews/008/505/801/original/bitcoin-logo-color-illustration-png.png",
              mining_type: MiningType.first
            },
          ]
  
      coins.each do | coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  #--------------------------------------------------

  desc "Cadastra os tipos de minereção"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]

      mining_types.each do | mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  #--------------------------------------------------


  private
  def show_spinner(msg_start,msg_end = "concluido com sucesso")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin 
    yield
    spinner.success("(#{msg_end})")
  end
end

  #--------------------------------------------------