import 'package:uuid/uuid.dart';
import 'dart:async';
import './FeedItem.dart';
import 'package:meta/meta.dart';
import './RSSFeed.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

abstract class Feed {
  static final _uuidGenerator = new Uuid();
  static String getNewUniqueFeedID() => _uuidGenerator.v4();

  @protected
  final StreamController _didUpdate;
  final String uniqueID;

  Duration _updateFrequency;
  get updateFrequency => _updateFrequency;

  List<FeedItem> _items;
  get items => _items;
  @protected
  set items(List<FeedItem> value) => _items = value;

  String _title;
  get title => _title;
  @protected
  set title(String value) => _title = value;

  String _preferredTitle;
  get preferredTitle => _preferredTitle;
  @protected
  set preferredTitle(String value) => _preferredTitle = value;

  @protected
  static final String defaultFeedName = "Unnamed Feed";

  final bool isPublic;

  Feed(
      {@required Duration updateFrequency,
      @required this.uniqueID,
      String feedName,
      String preferredFeedName,
      bool isPublic})
      : _didUpdate = StreamController.broadcast(),
        _updateFrequency = updateFrequency,
        _title = feedName ?? defaultFeedName,
        _preferredTitle = preferredFeedName ?? defaultFeedName,
        isPublic = isPublic ?? true {
    items = new List<FeedItem>();
  }

  factory Feed.fromJSON(Map<String, dynamic> feedJSON) {
    switch (feedJSON["type"]) {
      case "RSS":
        return RSSFeed.fromJSON(feedJSON);
        break;
      default:
        throw new Exception("unknown feed type ${feedJSON["type"]}");
    }
  }

  @mustCallSuper
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'updateFrequency': updateFrequency.inSeconds,
      "uniqueID": uniqueID,
      "name": title,
      "preferredName": preferredTitle
    };

    switch (this.runtimeType) {
      case RSSFeed:
        json["type"] = "RSS";
        break;
      default:
        throw new Exception("unknown feed type ${this.runtimeType}");
    }

    return json;
  }

  StreamSubscription listenForUpdates(fn()) {
    //TODO check if there really are updates, and only call if there are
    return _didUpdate.stream.listen((_) => fn());
  }

  FeedItem getFeedItemFromJSON(Map<String, dynamic> json);

  Future<void> loadItemsFromDisc() async {
    print("loading from disc");

    String filename = uniqueID + ".json";

    Directory directory = await getApplicationDocumentsDirectory();
    String fullPath = directory.path + "/" + filename;

    if (FileSystemEntity.typeSync(fullPath) == FileSystemEntityType.notFound) {
      print("loading feed $uniqueID from disc, but file does not exist!");
      return;
    }

    final file = File(fullPath);

    String contents = await file.readAsString();
    Map<String, dynamic> jsonObject = json.decode(contents);

    _items.clear();
    for (Map<String, dynamic> itemJSON in jsonObject["items"]) {
      _items.add(getFeedItemFromJSON(itemJSON));
    }

    print("finished loading from disc");
  }

  Future _saveItemsToDisc() async {
    print("saving feed $uniqueID to disc");

    String filename = uniqueID + ".json";

    Directory directory = await getApplicationDocumentsDirectory();

    final file = File(directory.path + "/" + filename);
    String jsonString = json.encode({"items": items});

    await file.writeAsString(jsonString);
  }

  @mustCallSuper
  Future syncFeed() async {
    _didUpdate.add(null);

    await _saveItemsToDisc();
  }
}
