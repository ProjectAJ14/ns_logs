import 'package:flutter/material.dart';

import '../../../utils/methods.dart';
import '../../ns_logs.dart';
import '../../utils/map_extension.dart';

class ApiLogsWidget extends StatefulWidget {
  const ApiLogsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ApiLogsWidget> createState() => _ApiLogsWidgetState();
}

class _ApiLogsWidgetState extends State<ApiLogsWidget> {
  bool _showOnlyErrors = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        CheckboxListTile(
          title: const Text('SHOW ONLY ERROR'),
          value: _showOnlyErrors,
          onChanged: (_) {
            setState(() {
              _showOnlyErrors = !_showOnlyErrors;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ExpansionPanelList.radio(
          children: <ExpansionPanel>[
            ...DevAPIService.instance.apiCalls.where((element) {
              if (_showOnlyErrors) {
                return element.statusCode < APIStatusCode.success;
              }
              return true;
            }).map(
              (apiCall) {
                var statusCode = apiCall.statusCode;
                var success = statusCode < APIStatusCode.badRequest;

                var color = success ? Colors.green : Colors.red;
                return ExpansionPanelRadio(
                  value: apiCall.id,
                  headerBuilder: (_, isExpanded) {
                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                            apiCall.type,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: color,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                '$statusCode',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              apiCall.dateTime.toString(),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            apiCall.path,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Time Taken : ${apiCall.duration.inMilliseconds}'
                            ' Milliseconds'
                            ' [${apiCall.duration}]',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Colors.orange,
                                    ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    );
                  },
                  body: InkWell(
                    onLongPress: () {
                      copyToClipBoard(
                        value: 'Request[${apiCall.path}] '
                            ': ${apiCall.data!.toPretty()}'
                            'Response : ${apiCall.response!.toPretty()}',
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (apiCall.data != null && apiCall.data!.isNotEmpty)
                            Text(
                              'Request data : ${apiCall.data!.toPretty()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.brown,
                                  ),
                            ),
                          Text(
                            'Response Data ${apiCall.response!.toPretty()}',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: color,
                                    ),
                          ),
                          Text(
                            'Tap & Hold To Copy',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.pink,
                                    ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).toList()
          ],
        ),
      ],
    );
  }
}
