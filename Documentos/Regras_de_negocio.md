<!-- Regras de Negócio -->
<div align="center">

  # Regras de Negócio

</div>

## Início do Programa 
-	Verifica se a central de relacionamento (CRC) está ligada, se não estiver, chama a central de relacionamento.
-	Verifica o usuário e senha nos parâmetros, se não estiver definido, solicita usuário e senha pela tela do login.
-	Valida o usuário, senha e computador.
-	Chama a tela de identificação do candidato.

## Tela de Login
-	Valida o usuário, senha e computador.
-	Valida o horário de funcionamento.
-	Recebe os parâmetros de funcionando do sistema de acordo com a UF.
-	Chama a tela de identificação do candidato.

## Tela de Identificação do Candidato
-	Solicita o RENACH ou CPF de acordo com a UF.
-	Valida o candidato.
-	Retorna os dados do candidato.
-	Habilita os botões para prova ou simulado dependendo do curso escolhido.
-	Verifica exceção digital (chama a tela de foto ou de biometria com foto)

## Tela de Captura de Foto (caso o candidato seja exceção digital)
-	Captura a foto do candidato.
-	Envia a foto para o servidor (GRUPO CRIAR).
-	Chama a tela de confirmação da prova, simulado ou teste do teclado.

```
Essa tela também registra a presença do aluno exceção digital,
caso sejá o registro de presença, não chama a próxima tela,
executa a operação de registro de presença e retorna a tela de identificação.
```

## Tela de Biometria e Foto (caso o candidato tenha a biometria)
-	Chama o applet da biometria passando os parâmetros. 
-	Verifica a biometria, se for uma biometria válida captura a foto.
-	Envia a foto para o servidor (GRUPO CRIAR).
-	Chama a tela de confirmação da prova, simulado ou teste do teclado.

```
Essa tela também registra a presença do aluno com biometria,
caso seja o registro de presença, não chama a próxima tela,
executa a operação de registro de presença e retorna a tela de identificação.
```

## Tela de Teste do teclado (de acordo com cada estado) 
-	Verifica o teclado
-	Chama a tela de confirmação da prova ou simulado 

## Tela de Confirmação do candidato 
-	Exibe os dados do candidato na tela
-	Exibe o botão de instruções de acordo com a UF
-	Gera a prova 
-	Verifica o bloqueio da prova 
-	Inicia o monitoramento 
-	Verifica o monitoramento 
-	Atualiza o andamento da prova 
-	Chama a tela de questionário

## Tela de Questionário
-	Monta questionário
-	Exibe imagem da questão
-	Exibe a primeira questão ou a questão que parou (prova não finalizada)
-	Atualiza o andamento a cada 1 minuto
-	Atualiza monitoramento a cada 30 seg
-	Verificar monitoramento a cada 1 min
-	Verifica o bloqueio a cada 15 seg
-	Atualiza o cronômetro a cada 1seg
-	Travar o cronômetro sempre que aparecer um aviso
-	Reiniciar o monitoramento sempre que o mesmo não estiver presente ou funcionando
-	Não permitir finalizar a prova antes de 15min. (de acordo com cada UF)
-	Não permitir finalizar a prova com respostas em aberto (de acordo com cada UF)
-	Permitir finalizar o prova com questões em aberto se o tempo acabar (de acordo com cada UF)
-	Avisar que tem questões sem respostas mais permitir finalizar a prova (de acordo com cada UF)
-	Perguntar se quer realmente fechar a prova
-	Finalizar a prova ou simulado por tempo
-	Chamar a tela de resultado

## Tela de Resultado
-	Exibir botões de gráficos (de acordo com cada UF)
-	Exibir botões de relatórios (Gabarito e Questões) (de acordo com cada UF)
-	Montar os gráficos
-	Exibir resumo lateral por matéria

## Operações XML

|Operação| Descrição                                            |
|--------|------------------------------------------------------|
|  100100|Informações do CFC                                    |
|  100110|Informações do Aluno + Sincronização Provas/Servidores|
|  100300|Informações do Aluno                                  |
|  100700|Informações Cadastro do Aluno + Acessos/Processos     |
|  200100|Informações da Prova                                  |
|  200200|Valida Monitoramento da Prova                         |
|  200300|Sem informação                                        |
|  200400|Encerramento/Resultado da Prova                       |
|  200500|Validação Biometria (Imagem) na Prova                 |
|  200710|Validação dos Processos e Serviços                    |
|  400100|Validação Monitoramento                               |

<!-- Fluxograma -->
<br/>
<details><summary>Fluxograma</summary><br/><img src="https://user-images.githubusercontent.com/117082797/201097981-2ceb97b6-8511-4b33-a93c-1d19a2ebebf1.png"></details>

<!-- Logo Rodapé -->
#
<div align="Center">
  <a href="https://grupocriar.com.br/">
    <img src="https://user-images.githubusercontent.com/117082797/201110300-c0fc384f-2efb-4160-9d48-fa8dfb2ef26a.png" alt="Grupo Criar">
  </a>
</div>