import os
import subprocess
from tkinter import Tk, filedialog

# Função para listar os dispositivos enumerados
def listar_dispositivos():
    output = subprocess.check_output(['adb', 'devices']).decode('utf-8')
    lines = output.split('\n')[1:]  # Ignora a primeira linha

    dispositivos = []
    for line in lines:
        if line.strip() != '':
            dispositivo = line.split('\t')[0]
            dispositivos.append(dispositivo)

    return dispositivos

# Função para parear o dispositivo com a TV
def parear_tv(dispositivos):
    print("Dispositivos:")
    for i, dispositivo in enumerate(dispositivos):
        print(f"{i+1}. {dispositivo}")

    escolha = input("Escolha o número do dispositivo que deseja parear: ")
    if escolha.isdigit() and int(escolha) <= len(dispositivos):
        dispositivo_escolhido = dispositivos[int(escolha) - 1]
        print(f"Pareando o dispositivo '{dispositivo_escolhido}' com a TV...")
        
        comando = f"adb pair {dispositivo_escolhido}"
        subprocess.run(comando, shell=True)
        
        print("Pareamento realizado com sucesso.")
    else:
        print("Opção inválida.")

# Função para carregar um vídeo
def carregar_video():
    escolha = input("Como você deseja carregar o vídeo?\n1. Por URL\n2. De um arquivo local\nEscolha uma opção: ")

    if escolha == "1":
        url = input("Digite a URL do vídeo: ")
        comando = f"adb loadvideo --url {url}"
        subprocess.run(comando, shell=True)
        print(f"Carregando vídeo por URL: {url}")
    elif escolha == "2":
        root = Tk()
        root.withdraw()

        caminho_arquivo = filedialog.askopenfilename()
        if caminho_arquivo:
            comando = f"adb loadvideo --file {caminho_arquivo}"
            subprocess.run(comando, shell=True)
            print(f"Carregando vídeo do arquivo local: {caminho_arquivo}")
        else:
            print("Nenhum arquivo selecionado.")
    else:
        print("Opção inválida.")

# Menu principal
def menu_principal():
    while True:
        print("\n=== Menu Principal ===")
        print("1. Listar dispositivos")
        print("2. Parear dispositivo com TV")
        print("3. Carregar vídeo")
        print("0. Sair")

        escolha = input("Escolha uma opção: ")

        if escolha == "1":
            dispositivos = listar_dispositivos()
            print("\nDispositivos:")
            for i, dispositivo in enumerate(dispositivos):
                print(f"{i+1}. {dispositivo}")
        elif escolha == "2":
            parear_tv(dispositivos)
        elif escolha == "3":
            carregar_video()
        elif escolha == "0":
            print("Encerrando o programa.")
            break
        else:
            print("Opção inválida. Por favor, escolha uma opção válida.")

# Executar o menu principal
menu_principal()
