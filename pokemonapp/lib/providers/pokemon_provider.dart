import 'package:flutter/material.dart';

import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  List<dynamic> pokemons = [];

  Map<String, dynamic>? pokemonSelecionado;

  Map<String, dynamic>? pokemonPesquisado;

  bool carregando = false;

  String? erroPesquisa;

  Future<void> carregarPokemons() async {
    carregando = true;

    notifyListeners();

    pokemons = await PokemonService.buscarPokemons();

    carregando = false;

    notifyListeners();
  }

  Future<void> carregarDetalhes(
    int id,
  ) async {
    carregando = true;

    pokemonSelecionado = null;

    notifyListeners();

    pokemonSelecionado = await PokemonService.buscarDetalhes(
      id,
    );

    carregando = false;

    notifyListeners();
  }

  Future<void> pesquisarPorNome(String nome) async {
    carregando = true;
    pokemonPesquisado = null;
    erroPesquisa = null;
    notifyListeners();

    try {
      pokemonPesquisado = await PokemonService.buscarPorNome(nome);
    } catch (_) {
      erroPesquisa = 'Pokémon "$nome" não encontrado';
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> carregarAleatorio() async {
    carregando = true;
    notifyListeners();

    final aleatorio = await PokemonService.buscarAleatorio();
    pokemons = [aleatorio];

    carregando = false;
    notifyListeners();
  }
}
