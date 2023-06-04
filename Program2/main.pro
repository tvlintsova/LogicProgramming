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
        printCinemaStats(3).

end implement main

goal
    console::runUtf8(main::run).
