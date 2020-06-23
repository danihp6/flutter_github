class Notification {
  String _title;
  String _body;
  String _sender;
  String _receiver;
  String _post;

  Notification(title, body, sender, receiver, post) {
    this._title = title;
    this._body = body;
    this._sender = sender;
    this._receiver = receiver;
    this._post = post;
  }

  Notification.fromMap(Map<String, dynamic> info)
      : _title = info['notification']['title'],
        _body = info['notification']['body'],
        _sender = info['data']['sender'],
        _receiver = info['data']['receiver'],
        _post = info['data']['post'];

  Map<String, dynamic> toMap() => {
        'notification': {'title': _title, 'body': _body},
        'data': {'sender': _sender, 'receiver': _receiver, 'post': _post}
      };

  get title => this._title;

  set title(title) => this._title = title;

  get body => this._body;

  set body(body) => this._body = body;

  get sender => this._sender;

  set sender(sender) => this._sender = sender;

  get receiver => this._receiver;

  set receiver(receiver) => this._receiver = receiver;

  get post => this._post;

  set post(post) => this._post = post;
}
