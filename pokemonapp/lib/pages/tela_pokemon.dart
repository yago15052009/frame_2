import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import 'tela_detalhes_pokemon.dart';

class TelaPokemon extends StatefulWidget {
  const TelaPokemon({super.key});

  @override
  State<TelaPokemon> createState() => _TelaPokemonState();
}

class _TelaPokemonState extends State<TelaPokemon> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── BUSCA POR NOME ──
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nome do Pokémon...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (v) {
                      if (v.trim().isNotEmpty) {
                        context.read<PokemonProvider>().pesquisarPorNome(v.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final nome = _controller.text.trim();
                    if (nome.isNotEmpty) {
                      context.read<PokemonProvider>().pesquisarPorNome(nome);
                    }
                  },
                  child: const Text('Pesquisar'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── RESULTADO DA PESQUISA ──
            if (provider.erroPesquisa != null)
              Text(
                provider.erroPesquisa!,
                style: const TextStyle(color: Colors.red),
              ),

            if (provider.pokemonPesquisado != null) ...[
              Card(
                color: Colors.amber.shade50,
                child: ListTile(
                  leading: Image.network(
                    provider.pokemonPesquisado!['imagem'],
                    width: 60,
                  ),
                  title: Text(
                    provider.pokemonPesquisado!['nome'].toString().toUpperCase(),
                  ),
                  subtitle: Text('Tipo: ${provider.pokemonPesquisado!['tipo']}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TelaDetalhesPokemon(
                          idPokemon: provider.pokemonPesquisado!['id'],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],

            // ── BOTÕES ──
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PokemonProvider>().carregarPokemons();
                    },
                    child: const Text('Buscar Pokémon'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PokemonProvider>().carregarAleatorio();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pokémon Aleatório'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (provider.carregando) const CircularProgressIndicator(),

            if (!provider.carregando)
              Expanded(
                child: ListView.builder(
                  itemCount: provider.pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = provider.pokemons[index];

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          pokemon['imagem'],
                          width: 60,
                        ),
                        title: Text(
                          pokemon['nome'].toString().toUpperCase(),
                        ),
                        subtitle: Text('Tipo: ${pokemon['tipo']}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TelaDetalhesPokemon(
                                idPokemon: pokemon['id'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
