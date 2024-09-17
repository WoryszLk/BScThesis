import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Map <String, List <String>> competitionRules = {
  'FBI': [
    'Zadanie 1: 2,7 m - 6 strzałów (1 magazynek)',
    'Zadanie 2: 4,6 m - 12 strzałów (2 magazynki)',
  ],
};