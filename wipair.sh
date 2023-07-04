#!/bin/bash

# Função para listar os dispositivos enumerados
listar_dispositivos() {
    dispositivos=()
    while IFS= read -r line; do
        dispositivo=$(echo "$line" | awk '{print $1}')
        if [[ ! -z "$dispositivo" ]]; then
            dispositivos+=("$dispositivo")
        fi
    done < <(adb devices | tail -n +2)

    for i in "${!dispositivos[@]}"; do
        echo "$((i+1)). ${dispositivos[i]}"
    done

    return 0
}

# Função para parear o dispositivo com a TV
parear_tv() {
    dispositivos=("$@")
    echo "Dispositivos:"
    for i in "${!dispositivos[@]}"; do
        echo "$((i+1)). ${dispositivos[i]}"
    done

    read -p "Escolha o número do dispositivo que deseja parear: " escolha
    if [[ $escolha =~ ^[0-9]+$ ]] && (( escolha >= 1 && escolha <= ${#dispositivos[@]} )); then
        dispositivo_escolhido=${dispositivos[escolha-1]}
        echo "Pareando o dispositivo '$dispositivo_escolhido' com a TV..."
        adb pair "$dispositivo_escolhido"
        echo "Pareamento realizado com sucesso."
    else
        echo "Opção inválida."
    fi

    return 0
}

# Função para carregar um vídeo
carregar_video() {
    read -p "Como você deseja carregar o vídeo?
1. Por URL
2. De um arquivo local
Escolha uma opção: " escolha

    if [[ $escolha == "1" ]]; then
        read -p "Digite a URL do vídeo: " url
        echo "Carregando vídeo por URL: $url"
        adb loadvideo --url "$url"
    elif [[ $escolha == "2" ]]; then
        read -e -p "Digite o caminho do arquivo local: " caminho_arquivo
        if [[ -f $caminho_arquivo ]]; then
            echo "Carregando vídeo do arquivo local: $caminho_arquivo"
            adb loadvideo --file "$caminho_arquivo"
        else
            echo "Arquivo não encontrado: $caminho_arquivo"
        fi
    else
        echo "Opção inválida."
    fi

    return 0
}

# Menu principal
menu_principal() {
    while true; do
        echo -e "\n=== Menu Principal ==="
        echo "1. Listar dispositivos"
        echo "2. Parear dispositivo com TV"
        echo "3. Carregar vídeo"
        echo "0. Sair"

        read -p "Escolha uma opção: " escolha

        case $escolha in
            1)
                dispositivos=($(listar_dispositivos))
                echo -e "\nDispositivos:"
                for i in "${!dispositivos[@]}"; do
                    echo "$((i+1)). ${dispositivos[i]}"
                done
                ;;
            2)
                parear_tv "${dispositivos[@]}"
                ;;
            3)
                carregar_video
                ;;
            0)
                echo "Encerrando o programa."
                break
                ;;
            *)
                echo "Opção inválida."
                ;;
        esac
    done

    return 0
}

# Executar o menu principal
menu_principal
