% Copyright

implement main
    open core, stdio, file

domains
    address = string.
    phone = string.

class facts - cinemaDb
    cinema : (integer Id, string Name, address CinemaAddress, phone PhoneNumber, integer SeatsCount, integer HallsCount) nondeterm.
    cinema_hall : (integer Id, integer CinemaId, integer NumberInCinema, integer SeatsCount) nondeterm.
    film : (integer Id, string Title, integer IssueYear, string Director, string Genre) nondeterm.
    showing : (integer FilmId, integer CinemaId, integer CinemaHallId, string Date, string Time, real Price) nondeterm.
    stats : (integer ShowingCount, real ShowingPricesSum) single.

clauses
    stats(0, 0).

class predicates
    printCinemas : ().
    printCinemaById : (integer CinemaId).
    cinemasWithOneHall : ().
    cinemasWithManyHalls : ().
    printCinemaStats : (integer CinemaId).

clauses
    printCinemas() :-
        cinema(_, Name, CinemaAddress, PhoneNumber, SeatsCount, HallsCount),
        write(Name, " ", CinemaAddress, " ", PhoneNumber, " ", SeatsCount, " ", HallsCount),
        nl,
        fail.
    printCinemas() :-
        write("All cinemas shown\n\n").

clauses
    printCinemaById(CinemaId) :-
        cinema(CinemaId, Name, CinemaAddress, PhoneNumber, SeatsCount, HallsCount),
        write(Name, " ", CinemaAddress, " ", PhoneNumber, " ", SeatsCount, " ", HallsCount),
        nl,
        fail.
    printCinemaById(CinemaId) :-
        write("Cinema with id=", CinemaId, " shown\n\n").

clauses
    cinemasWithOneHall() :-
        cinema(_, Name, CinemaAddress, PhoneNumber, SeatsCount, HallsCount),
        HallsCount = 1,
        write(Name, " ", CinemaAddress, " ", PhoneNumber, " ", SeatsCount),
        nl,
        fail.
    cinemasWithOneHall() :-
        write("Cinemas with one hall shown\n\n").

clauses
    cinemasWithManyHalls() :-
        cinema(_, Name, CinemaAddress, PhoneNumber, SeatsCount, HallsCount),
        HallsCount > 1,
        write(Name, " ", CinemaAddress, " ", PhoneNumber, " ", SeatsCount),
        nl,
        fail.
    cinemasWithManyHalls() :-
        write("Cinemas with one more halls shown\n\n").

clauses
    printCinemaStats(CinemaId) :-
        assert(stats(0, 0)),
        showing(_, CinemaId, _, _, _, Price),
        stats(ShowingCount, ShowingPricesSum),
        assert(stats(ShowingCount + 1, ShowingPricesSum + Price)),
        fail.

    printCinemaStats(CinemaId) :-
        stats(ShowingCount, ShowingPricesSum),
        writef("In Cinema with id=%:\nShowing Count: %\nAvarage Ticket Price: %\n\n", CinemaId, ShowingCount, ShowingPricesSum / ShowingCount).

/* Дальнейшие предикаты и правила используют списки */
class predicates
    elements_count : (A*) -> integer N.
    elements_sum : (real* List) -> real Sum.
    elements_avg : (real* List) -> real Avg determ.
    contains : (integer, integer*) determ.
    showsCountInCinema : (integer CinemaId) -> integer N determ.
    cinemaIdsHaveHallsCount : (integer HallsCount) -> integer* CinemaIds determ.
    avgShowPriceInCinemaWithShowingMinPrice : (integer CinemaId, real MinPrice) -> real Avg determ.
    cinemaIdsByFilmGenre : (string Genre) -> integer* CinemaIds determ.
    filmIdsByGenre : (string Genre) -> integer* FilmIds determ.

clauses
    elements_count([]) = 0.
    elements_count([_ | T]) = elements_count(T) + 1.

    elements_sum([]) = 0.
    elements_sum([H | T]) = elements_sum(T) + H.

    elements_avg(L) = elements_sum(L) / elements_count(L) :-
        elements_count(L) > 0.

    contains(X, [X | _]) :-
        !.
    contains(X, [_ | T]) :-
        contains(X, T).

    showsCountInCinema(CinemaId) = elements_count([ FilmId || showing(FilmId, CinemaId, _, _, _, _) ]).

    cinemaIdsHaveHallsCount(HallsCount) = List :-
        List = [ CinemaId || cinema(CinemaId, _, _, _, _, HallsCount) ].

    avgShowPriceInCinemaWithShowingMinPrice(CinemaId, MinPrice) = Avg :-
        Avg =
            elements_avg(
                [ Price ||
                    showing(_, CinemaId, _, _, _, Price),
                    Price >= MinPrice
                ]).

    filmIdsByGenre(Genre) = List :-
        List = [ FilmId || film(FilmId, _, _, _, Genre) ].

    cinemaIdsByFilmGenre(Genre) = List :-
        FilmIds = filmIdsByGenre(Genre),
        List =
            [ CinemaId ||
                showing(FilmId, CinemaId, _, _, _, _),
                contains(FilmId, FilmIds)
            ].

class predicates
    writeCinemaMainInfo : (integer CinemaId).
    writeCinemaIds : (integer* CinemaIds).
    writeCinemaAddressesByCinemaIds : (integer* CinemaIds).
    writeCinemaHaveFilmWithGenre : (integer CinemaId, string Genre) determ.

clauses
    writeCinemaMainInfo(CinemaId) :-
        cinema(CinemaId, Name, Address, _, _, _),
        write("Название сети кинотеатров: ", Name),
        write("; Адрес: ", Address),
        fail.
    writeCinemaMainInfo(CinemaId) :-
        write("CinemaId=", CinemaId),
        nl.

    writeCinemaIds(L) :-
        foreach CinemaId = list::getMember_nd(L) do
            write(CinemaId, " ")
        end foreach.

    writeCinemaAddressesByCinemaIds(CinemaIds) :-
        foreach CinemaId = list::getMember_nd(CinemaIds) do
            writeCinemaMainInfo(CinemaId)
        end foreach.

    writeCinemaHaveFilmWithGenre(CinemaId, Genre) :-
        CinemaIds = cinemaIdsByFilmGenre(Genre),
        contains(CinemaId, CinemaIds),
        write("true"),
        fail
        or
        CinemaIds = cinemaIdsByFilmGenre(Genre),
        not(contains(CinemaId, CinemaIds)),
        write("false").

clauses
    run() :-
        consult("../cinema.txt", cinemaDb),
        fail.

    run() :-
        printCinemas(),
        printCinemaById(1),
        cinemasWithOneHall(),
        cinemasWithManyHalls(),
        printCinemaStats(1),
        printCinemaStats(2),
        printCinemaStats(3),
        fail.

    run() :-
        CinemaId = 3,
        write("Количество показов в кинотеатре с id=", CinemaId),
        nl,
        write(showsCountInCinema(CinemaId)),
        nl,
        fail.

    run() :-
        CinemaHallsCount = 1,
        write("Идентификаторы кинотеатров с количеством залов=", CinemaHallsCount),
        nl,
        writeCinemaIds(cinemaIdsHaveHallsCount(CinemaHallsCount)),
        nl,
        fail.

    run() :-
        MinPrice = 720,
        CinemaId = 2,
        write("Средняя стоимость показов в кинотеатре с id=", CinemaId),
        write(" при учете минимальной стоимости билета ", MinPrice),
        nl,
        write(avgShowPriceInCinemaWithShowingMinPrice(CinemaId, MinPrice)),
        nl,
        fail.

    run() :-
        Genre = "boevik",
        write("Cinema addresses by film genre ", Genre),
        nl,
        writeCinemaAddressesByCinemaIds(cinemaIdsByFilmGenre(Genre)),
        nl,
        fail.

    run() :-
        CinemaId = 1,
        Genre = "boevik",
        write("Cinema with id=", CinemaId),
        write(" have showing with films of genre=", Genre),
        nl,
        write("Result: "),
        writeCinemaHaveFilmWithGenre(CinemaId, Genre),
        nl,
        fail.

    run() :-
        succeed.

end implement main

goal
    console::runUtf8(main::run).

