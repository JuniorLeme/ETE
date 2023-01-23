<!-- Logo ETE -->

<div align="center">
<a href="https://www.exameteoricoeletronico.com.br/site/">
<img src="https://user-images.githubusercontent.com/117082797/199989359-edd3a278-469c-4a6d-b98f-eceb8c6ebed7.jpg" alt="Exame Teórico Eletrônico" width="160rem"></a>


<strong>Versão exe:</strong> 4.1.0
</div>

<!-- Fim Logo ETE -->

##

<!-- Menu -->
<div align="center">

<!-- Início Regras_de_negocio.md -->
<a href="http://gitlab.grupocriar.com.br:8089/delphi/ete/-/blob/main/Documentos/Regras_de_negocio.md">
<img src="https://img.shields.io/static/v1?message=Regras%20de%20Neg%C3%B3cio&labelColor=021d48&color=d0d219&label=%20&style=plastic" width="250rem">   
<!-- Fim Regras_de_negocio.md -->


<!-- Início arquivo Instalacao_Cliente.md -->
<a href="http://gitlab.grupocriar.com.br:8089/delphi/ete/-/blob/main/Documentos/Instalacao_cliente.md">
<img src="https://img.shields.io/static/v1?message=Cliente&labelColor=021d48&color=d0d219&label=%20&style=plastic" width="120rem">
</a>
<!-- Fim Instalacao_cliente.md -->


<!-- Início Instalacao_desenvolvedor.md -->
<a href="http://gitlab.grupocriar.com.br:8089/delphi/ete/-/blob/main/Documentos/Instalacao_desenvolvedor.md">
<img src="https://img.shields.io/static/v1?message=Desenvolvedor&labelColor=021d48&color=d0d219&label=%20&style=plastic" width="205rem">
</a>
<!-- Fim Instalacao_desenvolvedor.md -->

</div>
 <!-- Fim Menu -->


<!-- Início Resumo -->  

## Resumo

O Sistema ETE (Exame Teórico Eletrônico) é um sistema que permite o acompanhamento e o gerenciamento da prova do exame teórico, exigido na
obtenção da CNH (Carteira Nacional de Habilitação) e na reabilitação.

Este sistema possibilita:
- A identificação dos Alunos através da biometria dactiloscópica e facial; 
- O monitoramento da sala de exame por meio da gravação de vídeo e áudio;
- O envio da prova para o Detran após finalização da mesma com pontuação positiva;
</details>

## Arquitetura

Este serviço foi criado com o padrão de sistemas MVC (Model, View e Controller), fazendo a comunicação com web services e 
posterior com o banco de dados.

Detalhes das tecnologias e integrações:

- Linguagem Delphi na IDE 10.4 (Sydney);

```
   Caminho padrão para a geração do executável: C:\Program Files (x86)\Criar\e-Prova XE.
```

- Estrutura de empacotamento do XML utilizando o SOAP (Simple Object Access Protocol);
- Envio e Recebimento dos dados via XML utilizando o gerenciador de servidores MCP (Master Control Program);
  <details><summary><strong>Servidores MCP</strong></summary><ul><li>http://servidor1.eprova.com.br:8080/mcp/Operations</li><li>http://servidor2.eprova.com.br:8080/mcp/Operations</li><li>http://servidor3.eprova.com.br:8080/mcp/Operations</li></ul></details>

  <details><summary><strong>WSDL (Web Services Description Language)</strong></summary><ul><li>http://servidor1.eprova.com.br:8080/mcp/Operations?wsdl</li><li>http://servidor2.eprova.com.br:8080/mcp/Operations?wsdl</li><li>http://servidor3.eprova.com.br:8080/mcp/Operations?wsdl</li></ul></details>

- Banco de dados MySQL (IDE SQL Manager 2007 for MySQL);
  
- Biometrika Sharp Digital
  <details><summary><strong>Servers</strong></summary>
    
    - Serviço: e-biometrika-sharp-digital, Versão= 1.0.31, Ip Local Server: http://127.0.0.1:9292/
		  <ul>
        <li>mcp1 - http://ebiometrikasharp.mcp1.grupocriar.com.br</li>
		    <li>mcp2 - http://ebiometrikasharp.mcp2.grupocriar.com.br</li>
		    <li>mcp3 - http://ebiometrikasharp.mcp3.grupocriar.com.br</li>
		    <li>comp_server1 - http://ebiometrikasharp.wrapper1.grupocriar.com.br</li>
		    <li>comp_server2 - http://ebiometrikasharp.wrapper2.grupocriar.com.br</li>
		    <li>comp_server3 - http://ebiometrikasharp.wrapper3.grupocriar.com.br</li>
      </ul>
  </details>    
  
- Biometrika Sharp Fotos
  <details><summary><strong>Servers</strong></summary>
    
    - Serviço: e-biometrika-sharp-fotos, Versão: 1.0.31, Ip local server: http://127.0.0.1:9393/     
        <ul>
          <li>mcp1 - http://ebiometrikasharp.mcp1.grupocriar.com.br</li>
          <li>mcp2 - http://ebiometrikasharp.mcp2.grupocriar.com.br</li>
          <li>mcp3 - http://ebiometrikasharp.mcp3.grupocriar.com.br</li>
          <li>comp_server1 - http://ebiometrikasharp.wrapper1.grupocriar.com.br</li>
          <li>comp_server2 - http://ebiometrikasharp.wrapper2.grupocriar.com.br</li>
          <li>comp_server3 - http://ebiometrikasharp.wrapper3.grupocriar.com.br</li>
        </ul>    
  </details>

<!-- Fim Resumo -->

##

<div align="Center">
  <a href="https://grupocriar.com.br/">
    <img src="https://user-images.githubusercontent.com/117082797/201110300-c0fc384f-2efb-4160-9d48-fa8dfb2ef26a.png" alt="Grupo Criar">
  </a>
</p>
