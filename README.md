# rantor_web_app
Sammanfattning:

Visar ett linjediagram för sparkontoräntor över tid.

Implementation:

scrape: Scrapear compricer på 0 månader ränta på sparkonton. Skriver till fil.

database_sqlite: Läser från fil. Lagrar i databas.

rantor: Webbsaker + lite logik
    javascript och css i assets/
    html och större delen av koden i lib/rantor_web/live/
    html även i: lib/rantor_web/templates/layout/

## Uppstart
### Front-end
0. [Installera Elixir](https://elixir-lang.org/install.html)
0. Installera dependencies, ```cd rantor/ \n mix deps.get

```sh
### Databas
0. 
## Uppstart
### Front-end
* [Installera Elixir](https://elixir-lang.org/install.html)
* Installera dependencies, 
    * Elixir
```
cd rantor/ 
mix deps.get
```
    * node_modules
```
cd assets/
npm install
```
* Run the server
```
cd ..
mix phx.server
```

### Databas
* Install Python
* Populate the database
