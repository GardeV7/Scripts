from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import requests


class ActionShowTournaments(Action):

    def name(self) -> Text:
        return "action_show_tournaments"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        requests.get('http://localhost:5000/show_tournaments')
        return []


class ActionRegisterPlayer(Action):

    def name(self) -> Text:
        return "action_register_player"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        if len(tracker.latest_message['entities']) > 0:
            game = tracker.latest_message['entities'][0]['entity']
        else:
            game = None
        requests.post('http://localhost:5000/register_player', json={"game": game})
        return []


class ActionRemovePlayer(Action):

    def name(self) -> Text:
        return "action_remove_player"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        if len(tracker.latest_message['entities']) > 0:
            game = tracker.latest_message['entities'][0]['entity']
        else:
            game = None
        requests.post('http://localhost:5000/remove_player', json={"game": game})
        return []
