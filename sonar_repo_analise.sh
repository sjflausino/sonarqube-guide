#!/bin/bash

# Nome padrão do token
token_name="LOCAL_TOKEN"

# Função para exibir o guia rápido
function exibir_guia_rapido() {
    echo "Guia Rápido:"
    echo "Este script faz o seguinte:"
    echo "1. Verifica se as variáveis de ambiente SONAR_LOGIN, SONAR_PASSWORD e SONAR_URL estão definidas."
    echo "2. Verifica se a variável de ambiente SONAR_TOKEN está definida."
    echo "3. Se o SONAR_TOKEN não estiver definido, verifica se o token '$token_name' já existe no SonarQube."
    echo "4. Se o token já existir, apaga o token antigo e gera um novo token."
    echo "5. Se o token não existir, gera um novo token."
    echo "6. Exporta o token gerado como variável de ambiente SONAR_TOKEN."
    echo "7. Executa o comando Maven 'mvn sonar:sonar' com o token gerado ou existente."
    echo "8. Exporta o SONAR_TOKEN ao final."
    echo ""
    echo "O script continuará em 5 segundos..."
    sleep 5
}

# Exibe o guia rápido
exibir_guia_rapido

# Verifica se as variáveis de ambiente SONAR_LOGIN, SONAR_PASSWORD e SONAR_URL estão definidas
if [ -z "$SONAR_LOGIN" ] || [ -z "$SONAR_PASSWORD" ] || [ -z "$SONAR_URL" ]; then
    echo "As variáveis de ambiente SONAR_LOGIN, SONAR_PASSWORD e SONAR_URL devem estar definidas."
    exit 1
fi

# Verifica se a variável de ambiente SONAR_TOKEN está definida
if [ -z "$SONAR_TOKEN" ]; then
    echo "Variável de ambiente SONAR_TOKEN não encontrada. Verificando se o token '$token_name' já existe..."

    # Faz a requisição para listar os tokens existentes
    response=$(curl -s -u "$SONAR_LOGIN:$SONAR_PASSWORD" -X GET "$SONAR_URL/api/user_tokens/search")

    # Verifica se o token já existe
    token_exists=$(echo $response | grep -oP '(?<="name":")'"$token_name"'(?=")')

    if [ -n "$token_exists" ]; then
        echo "Token '$token_name' já existe. Apagando o token antigo e gerando um novo token..."

        # Faz a requisição para apagar o token antigo
        curl -s -u "$SONAR_LOGIN:$SONAR_PASSWORD" -X POST "$SONAR_URL/api/user_tokens/revoke" -d "name=$token_name"

        # Faz a requisição para criar o novo token
        response=$(curl -s -u "$SONAR_LOGIN:$SONAR_PASSWORD" -X POST "$SONAR_URL/api/user_tokens/generate" -d "name=$token_name")

        # Extrai o token da resposta
        token=$(echo $response | grep -oP '(?<="token":")[^"]*')

        # Verifica se o token foi gerado com sucesso
        if [ -n "$token" ]; then
            echo "Token gerado com sucesso: $token"
            # Exporta o token como variável de ambiente
            export SONAR_TOKEN="$token"
            echo "Token exportado como variável de ambiente SONAR_TOKEN"
        else
            echo "Falha ao gerar o token. Verifique suas credenciais e tente novamente."
            exit 1
        fi
    else
        echo "Token '$token_name' não encontrado. Gerando um novo token..."

        # Faz a requisição para criar o token
        response=$(curl -s -u "$SONAR_LOGIN:$SONAR_PASSWORD" -X POST "$SONAR_URL/api/user_tokens/generate" -d "name=$token_name")

        # Extrai o token da resposta
        token=$(echo $response | grep -oP '(?<="token":")[^"]*')

        # Verifica se o token foi gerado com sucesso
        if [ -n "$token" ]; then
            echo "Token gerado com sucesso: $token"
            # Exporta o token como variável de ambiente
            export SONAR_TOKEN="$token"
            echo "Token exportado como variável de ambiente SONAR_TOKEN"
        else
            echo "Falha ao gerar o token. Verifique suas credenciais e tente novamente."
            exit 1
        fi
    fi
else
    echo "Variável de ambiente SONAR_TOKEN encontrada: $SONAR_TOKEN"
fi

# Executa o comando Maven com o token gerado ou existente
mvn sonar:sonar -Dsonar.login=$SONAR_TOKEN

# Exporta o SONAR_TOKEN ao final
export SONAR_TOKEN
echo "SONAR_TOKEN exportado como variável de ambiente"