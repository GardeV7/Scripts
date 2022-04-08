from threading import Thread

import discord
import requests
import json
from flask import Flask, request, jsonify

app = Flask(__name__)
client = discord.Client()

channel = None
last_user = None


@app.route('/show_tournaments', methods=['GET'])
def show_tournaments():
    tournament_list = get_tournament_list()
    client.loop.create_task(channel.send(tournament_list))
    return jsonify(status=200)


@app.route('/register_player', methods=['POST'])
def register_player():
    res = add_participant(request.get_json()['game'], last_user)
    client.loop.create_task(channel.send(res))
    return jsonify(status=200)


@app.route('/remove_player', methods=['POST'])
def remove_player():
    res = remove_participant(request.get_json()['game'], last_user)
    client.loop.create_task(channel.send(res))
    return jsonify(status=200)


def get_tournament_list():
    file = open('data.json')
    data = json.load(file)
    file.close()
    string = ""
    for value in data['tournaments']:
        string += "------ " + value['name'] + "\nDescription: " + value['description'] + "\nParticipants:\n"
        i = 1
        for participant in value['participants']:
            string += str(i) + ") -> " + participant + "\n"
            i += 1

    return string


def add_participant(game_name, participant):
    if game_name is None:
        return "FAIL - please check if you selected correct game."
    with open('data.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
    for tournament in data['tournaments']:
        if game_name in tournament['name']:
            if participant not in tournament['participants']:
                tournament['participants'].append(participant)
                with open('data.json', 'w', encoding='utf-8') as file:
                    json.dump(data, file, indent=4)
                return "SUCCESS - you have been added to participants list."
    return "FAIL - you are already participating in selected tournament."


def remove_participant(game_name, participant):
    if game_name is None:
        return "FAIL - please check if you selected correct game."
    with open('data.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
    for tournament in data['tournaments']:
        if game_name in tournament['name']:
            if participant in tournament['participants']:
                tournament['participants'].remove(participant)
                with open('data.json', 'w', encoding='utf-8') as file:
                    json.dump(data, file, indent=4, ensure_ascii=False)
                return "SUCCESS - you have been removed from the tournament."
    return "FAIL - you are not participating in selected tournament."


def get_intent(sentence):
    url = "http://localhost:5005/model/parse"
    payload = {'text': sentence}
    try:
        response = requests.post(url, json=payload)
    except requests.exceptions.RequestException as e:
        raise SystemExit(e)
    return response.json()


def send_message(sentence):
    url = "http://localhost:5005/webhooks/rest/webhook"
    payload = {'message': sentence}
    try:
        response = requests.post(url, json=payload)
    except requests.exceptions.RequestException as e:
        raise SystemExit(e)
    return response.json()


def get_bot_response(message):
    r = send_message(message)
    bot_response = ""
    for i in r:
        bot_response += i['text']
    return bot_response


@client.event
async def on_ready():
    print('Logged in as {0.user}'.format(client))


@client.event
async def on_message(message):

    if message.author == client.user:
        return

    if message.content.startswith('$'):
        global channel, last_user
        channel = message.channel
        last_user = message.author.name

        bot_response = get_bot_response(message.content[1:])
        try:
            await message.channel.send(bot_response)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


Thread(target=lambda: app.run(port=5000, debug=True, use_reloader=False)).start()
client.run('KEY')
