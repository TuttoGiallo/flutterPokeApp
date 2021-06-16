import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:poke_team/model/pokemonItem.dart';
import 'package:poke_team/services/loaderDB.dart';

//TODO: leggere il count da chiamata.. usare quindi un client per effettuare due chiamate sequeniali
class LoaderApi {
  static final _urlAllPokemonApi =
      'https://pokeapi.co/api/v2/pokemon?limit=1118';
  static final _urlBaseItemCategoryApi =
      'https://pokeapi.co/api/v2/item-category/';

  static final LoaderApi _instance = LoaderApi._privateConstructor();
  List<String> _pokemonNames = [];
  List<PokemonItem> _pokemonItems = [];
  static bool _loadedItem = false;
  static bool _loadedPokemonNames = false;

  LoaderApi._privateConstructor();

  factory LoaderApi() {
    if (!_loadedItem || !_loadedPokemonNames) {
      _instance._loadAllPokemonNames().then((v) => _loadedPokemonNames = true);
      _instance._loadAllItems().then((v) => _loadedItem = true);
    }
    return _instance;
  }

  Future<void> _loadAllPokemonNames() async {
    var url = Uri.parse(_urlAllPokemonApi);
    var response = await get(url);
    Map pokeResp = jsonDecode(response.body);
    for (dynamic poke in pokeResp['results']) {
      _pokemonNames.add(poke['name']);
    }
  }

  Future<void> _loadAllItems() async {
    LoaderDB loaderDB = LoaderDB();
    _pokemonItems = await loaderDB.loadItems();
    if (_pokemonItems.isEmpty) {
      //TODO paralelizzare caricamento facendo un  await unico!
      await _loadCategoryItem(ItemCategory.choice, 'choice');
      await _loadCategoryItem(ItemCategory.heldItems, 'held-items');
      await _loadCategoryItem(ItemCategory.megaStones, 'mega-stones');
      _pokemonItems.forEach((pokemonItem) => loaderDB.storeItem(pokemonItem));
    }
    _pokemonItems.sort((i1, i2) => i1.name.compareTo(i2.name));
  }

  Future<void> _loadCategoryItem(
      ItemCategory itemCategory, String categoryName) async {
    Map jsonRespCategoryItem;
    Map jsonRespItem;
    Uri url;
    url = Uri.parse(_urlBaseItemCategoryApi + categoryName);
    var responseCategoryItem = await get(url);
    jsonRespCategoryItem = jsonDecode(responseCategoryItem.body);
    for (dynamic itemMapFromCategory in jsonRespCategoryItem['items']) {
      url = Uri.parse(itemMapFromCategory['url']);
      var responseItem = await get(url);
      jsonRespItem = jsonDecode(responseItem.body);
      List<dynamic> effectEntries = jsonRespItem['effect_entries'];
      PokemonItem pokemonItem = new PokemonItem(
          itemMapFromCategory['name'],
          effectEntries.firstWhere(
              (ee) => ee['language']['name'] == 'en')['short_effect'],
          itemCategory);
      _pokemonItems.add(pokemonItem);
    }
  }

  void _loadEffectsOfItems() {
    for (PokemonItem item in _pokemonItems) {
      PokemonItem.loadEffectsOfItem(item);
    }
  }

  List<PokemonItem> getAllPokemonItems() {
    return _pokemonItems;
  }

  List<String> getAllPokemonName() {
    return _pokemonNames;
  }

  static Future awaitLoadingInstance() async {
    Completer completer = new Completer();
    _readLoadingValues()
        .listen((cycleNumber) => print('loaderApi cycleNumber: $cycleNumber'),
            onDone: () {
      print('completer Api complete');
      completer.complete();
    });
    return completer.future;
  }

//TODO lanciare errori...
  static Stream<int> _readLoadingValues(
      {intervalMillisecond = 300, int maxCycle = 0}) async* {
    int i = 0;
    while (!_loadedItem || !_loadedPokemonNames) {
      yield i++;
      await Future.delayed(Duration(milliseconds: intervalMillisecond));
      print('loaderApi: $_loadedItem, $_loadedPokemonNames');

      if (maxCycle != 0 && maxCycle == i) break;
    }
    print('loader API done');
  }
}
