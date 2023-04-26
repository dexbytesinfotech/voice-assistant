/// Use of this source code is governed by a BSD-style license that can be
/// found in the LICENSE file.

library voice_assistant;

import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
import 'package:voice_assistant/src/util/project_util.dart';
import 'package:voice_assistant/src/util/shared_pref.dart';

export 'package:flutter/material.dart';

part 'src/screen/bottom_sheet.dart';
part 'src/screen/input_text_view.dart';
part 'src/screen/voice_assistant_view.dart';
part 'src/screen/voice_text_list_view.dart';
