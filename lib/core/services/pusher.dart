// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:nets/core/utils/constants_models.dart';
// import 'package:nets/feature/chat/data/models/message_model.dart';
//
// class PusherService {
//   static final PusherService _instance = PusherService._internal('', [], (messages) {});
//
//   factory PusherService() => _instance;
//
//   PusherService._internal(this._chatId, this.messages, this.onMessagesUpdated);
//
//   late PusherChannelsFlutter _pusher;
//   String? _currentChannelName;
//   final String _chatId;
//   final List<MessageModel> messages;
//   final Function(List<MessageModel>) onMessagesUpdated;
//
//   PusherService.withParams({required String chatId, required this.messages, required this.onMessagesUpdated}) : _chatId = chatId {
//     setupPusher();
//   }
//
//   Future<void> setupPusher() async {
//     _pusher = PusherChannelsFlutter.getInstance();
//
//     try {
//       // Get organization ID from local storage equivalent
//       final organizationId = ConstantsModels.loginModel?.data?.currentOrganizationId;
//
//       // Initialize Pusher
//       await _pusher.init(
//         apiKey: '71095cdd2001f2c383fc',
//         cluster: 'eu',
//         onConnectionStateChange: (currentState, previousState) {
//           log('Pusher connection state changed: from $previousState to $currentState');
//         },
//         onError: (message, code, error) {
//           log('Pusher connection error: $message, code: $code');
//         },
//       );
//
//       log('Pusher initialized');
//
//       // Connect to Pusher
//       await _pusher.connect();
//
//       // Subscribe to the organization channel
//       _currentChannelName = 'real-time-messaging.$organizationId';
//
//       await _pusher.subscribe(
//         channelName: _currentChannelName!,
//         onEvent: (event) {
//           if (event.eventName == 'messaging-event') {
//             handleMessageEvent(event);
//           } else {
//             log('Received other event: ${event.eventName}');
//           }
//         },
//       );
//
//       log('Subscribed to channel: $_currentChannelName');
//     } catch (e) {
//       log('Error setting up Pusher: $e');
//     }
//   }
//
//   void handleMessageEvent(PusherEvent event) {
//     if (event.data != null) {
//       try {
//         final data = jsonDecode(event.data!);
//         final message = data['message']['message'];
//
//         log('messaging-event: ${message['body'] ?? ""}');
//         log('props.chatId: $_chatId');
//
//         // Check if this message is for our chat
//         if (message['chatId'] == _chatId) {
//           final newMessage = MessageModel.fromJson(message);
//
//           // Add message to list
//           messages.add(newMessage);
//
//           // Notify listeners
//           onMessagesUpdated(List.from(messages));
//         }
//       } catch (e) {
//         log('Error processing message event: $e');
//       }
//     }
//   }
//
//   Future<void> disconnect() async {
//     try {
//       if (_currentChannelName != null) {
//         await _pusher.unsubscribe(channelName: _currentChannelName!);
//       }
//       await _pusher.disconnect();
//     } catch (e) {
//       log('Error disconnecting from Pusher: $e');
//     }
//   }
// }
