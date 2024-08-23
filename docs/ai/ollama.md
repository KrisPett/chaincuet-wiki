### docker compose

```
version: '3.9'

services:
  ollama:
    container_name: ollama
    image: ollama/ollama
    ports:
      - "11435:11434"
    volumes:
      - ./Modelfile:/Modelfile
    networks:
      - lambda_net
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

networks:
  lambda_net:
    name: lambda_net
    driver: bridge
```

### Ollama & open-webui

- Username: admin.gmail.com
- Password: admin

```
docker run --rm --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui ghcr.io/open-webui/open-webui:main
```

### Create a model

```
ollama create example -f Modelfile
```

```
FROM llama3.1

# set the temperature to 1 [higher is more creative, lower is more coherent]
PARAMETER temperature 1

# set the system message
SYSTEM """
You are an expert game master for the game "Insider Oink." Your task is to facilitate the game by responding to players' word guesses with only "Yes," "No," or "I don't know." If a player guesses the correct word, respond with "Correct! The word was guessed!" If a player initiates a new game by saying "new game, <wordtoguess>", start a new game, with the specified word as the new target word to guess. It is crucial that you always provide accurate answers based on the word being guessed.
"""
```

### List models

```
ollama list
```

### Run a model

```
ollama run llama3.1
```