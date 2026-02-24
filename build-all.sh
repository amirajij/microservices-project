#!/bin/bash

# Configurações
USERNAME="amirajij00"
VERSION=${1:-"1.0.0"} # Se não passar versão, ele usa 1.0.0
SERVICES=("user-service" "product-service" "order-service" "api-gateway")

echo "Build e push para o utilizador: $USERNAME"

for SERVICE in "${SERVICES[@]}"
do
    echo "------------------------------------------"
    echo "A processar: $SERVICE"
    echo "------------------------------------------"

    # Define o nome da imagem
    IMAGE_NAME="$USERNAME/$SERVICE"
    
    # Tenta obter o commit do Git (se falhar, usa 'no-git')
    GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "no-git")

    # 1. Build da imagem (usa a pasta com o nome do serviço)
    docker build -t ${IMAGE_NAME}:${VERSION} ./${SERVICE}
    
    # 2. Criar tags adicionais
    docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest
    docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:${GIT_COMMIT}

    # 3. Push de todas as tags
    echo "Enviando para o Docker Hub..."
    docker push ${IMAGE_NAME}:${VERSION}
    docker push ${IMAGE_NAME}:latest
    docker push ${IMAGE_NAME}:${GIT_COMMIT}
done

echo "Todos os serviços foram atualizados com sucesso!"