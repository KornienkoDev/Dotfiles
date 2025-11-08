#!/usr/bin/env python3
import gi
gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib
from gi.repository.Playerctl import Player
import argparse
import logging
import sys
import signal
import json
import os
from typing import List

logger = logging.getLogger(__name__)

def signal_handler(sig, frame):
    logger.info("Received signal to stop, exiting")
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)


class PlayerManager:
    def __init__(self, selected_player=None, excluded_player=[]):
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()
        self.manager.connect("name-appeared", self.on_player_appeared)
        self.manager.connect("player-vanished", self.on_player_vanished)

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

        self.selected_player = selected_player
        self.excluded_player = excluded_player.split(',') if excluded_player else []

        self.init_players()

    def init_players(self):
        for player in self.manager.props.player_names:
            if player.name in self.excluded_player:
                continue
            if self.selected_player and self.selected_player != player.name:
                continue
            self.init_player(player)

    def run(self):
        logger.info("Starting main loop")
        self.loop.run()

    def init_player(self, player):
        logger.info(f"Initialize new player: {player.name}")
        player = Playerctl.Player.new_from_name(player)
        player.connect("playback-status", self.on_playback_status_changed)
        player.connect("metadata", self.on_metadata_changed)
        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def get_players(self) -> List[Player]:
        return self.manager.props.players

    def write_output(self, text, player):
        output = {
            "text": text,
            "class": f"custom-{player.props.player_name}",
            "alt": player.props.player_name
        }
        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()

    def clear_output(self):
        sys.stdout.write("\n")
        sys.stdout.flush()

    def on_playback_status_changed(self, player, status):
        logger.debug(f"Playback status changed for {player.props.player_name}: {status}")
        self.on_metadata_changed(player, player.props.metadata)

    def get_first_playing_player(self):
        players = self.get_players()
        if not players:
            return None
        for player in reversed(players):
            if player.props.status == "Playing":
                return player
        return players[0]

    def show_most_important_player(self):
        current_player = self.get_first_playing_player()
        if current_player:
            self.on_metadata_changed(current_player, current_player.props.metadata)
        else:
            self.clear_output()

    def on_metadata_changed(self, player, metadata):
        logger.debug(f"Metadata changed for {player.props.player_name}")
        title = player.get_title() or ""
        title = title.replace("&", "&amp;")

        if not title.strip():
            self.clear_output()
            return

        icon = "" if player.props.status == "Playing" else ""
        track_info = f"{icon} {title}"

        current_playing = self.get_first_playing_player()
        if current_playing is None or current_playing.props.player_name == player.props.player_name:
            self.write_output(track_info, player)

    def on_player_appeared(self, manager, player):
        logger.info(f"Player appeared: {player.name}")
        if player.name in self.excluded_player:
            return
        if not self.selected_player or player.name == self.selected_player:
            self.init_player(player)

    def on_player_vanished(self, manager, player):
        logger.info(f"Player vanished: {player.props.player_name}")
        self.show_most_important_player()


def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--verbose", action="count", default=0)
    parser.add_argument("-x", "--exclude", help="Comma-separated list of excluded players")
    parser.add_argument("--player", help="Specific player to monitor")
    parser.add_argument("--enable-logging", action="store_true")
    return parser.parse_args()


def main():
    arguments = parse_arguments()

    if arguments.enable_logging:
        logfile = os.path.join(os.path.dirname(os.path.realpath(__file__)), "media-player.log")
        logging.basicConfig(
            filename=logfile,
            level=logging.DEBUG,
            format="%(asctime)s %(name)s %(levelname)s:%(lineno)d %(message)s"
        )

    logger.setLevel(max((3 - arguments.verbose) * 10, 0))

    player = PlayerManager(arguments.player, arguments.exclude)
    player.run()


if __name__ == "__main__":
    main()