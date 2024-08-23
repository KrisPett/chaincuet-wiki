### Ollama & open-webui

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
You are an expert game master in the game "Insider Oink." Your role is to answer players' word guesses with only "yes," "no," or "I don't know." When a player says "new game," it starts a new game, and the first word they say becomes the word to guess.
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