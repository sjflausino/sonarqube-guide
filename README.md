# Instalação do SonarQube

Este guia descreve os passos necessários para instalar e configurar o SonarQube em um ambiente local.

1. **Executar o SonarQube em um contêiner Docker:**
    Utilize o comando abaixo para iniciar o SonarQube em um contêiner Docker. O SonarQube estará disponível na porta 9000.
    ```sh
    docker run -d --name sonarqube -p 9000:9000 sonarqube
    ```

2. **Instalar o OpenJDK 17:**
    Atualize a lista de pacotes e instale o OpenJDK 17, que é necessário para executar o SonarQube.
    ```sh
    sudo apt update && sudo apt install openjdk-17-jdk
    ```

3. **Gerar um token de autenticação no SonarQube:**
    - Acesse o SonarQube em `http://localhost:9000` (ou o endereço onde o SonarQube está rodando).
    - Faça login com suas credenciais.
    - Vá para "My Account" (Minha Conta) > "Security" (Segurança).
    - Em "Tokens", clique em "Generate" (Gerar) e crie um novo token.

4. **Configurar o token de autenticação do SonarQube:**
    Exporte o token de autenticação do SonarQube como uma variável de ambiente. Substitua `'sqa_64f5653cbdcb1b1f1efeec7d425f4d5fff6da7be'` pelo seu token real.
    ```sh
    export SONAR_TOKEN='sqa_64f5653cbdcb1b1f1efeec7d425f4d5fff6da7be'
    ```

5. **Executar a análise do SonarQube:**
    Utilize o comando abaixo para executar a análise do SonarQube com o Maven, substituindo `$SONAR_TOKEN` pelo token de autenticação exportado.
    ```sh
    mvn sonar:sonar -Dsonar.login=$SONAR_TOKEN
    ```
