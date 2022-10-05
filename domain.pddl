(define (domain LEHAVRE)

    (:requirements :action-costs :adl :fluents :conditional-effects)
    (:types
        jugador casilla edificio bien oferta oferta_disponible ronda - object
    )

    (:constants
        C1 C2 C3 C4 C5 C6 C7 - casilla
        B1 B2 B3 HUNTINGLODGE WOOD CLAYMOUND ARTSCENTRE NINGUNO - edificio
        TRIGO VACA ARCILLA MADERA ACERO PIEL CARBON PESCADO FRANCOS - bien
        OFERTA1 OFERTA2 OFERTA3 OFERTA4 OFERTA5 OFERTA6 OFERTA7 - oferta
        OFERTA-TRIGO OFERTA-VACA OFERTA-ARCILLA OFERTA-MADERA OFERTA-PESCADO OFERTA-ACERO OFERTA-PIEL OFERTA-CARBON OFERTA-FRANCOS - oferta_disponible
        R1 R2 R3 R4 R5 R6 R7 - ronda
    )

    (:predicates
        (jugadorEn ?j - jugador ?c - casilla)
        (jugadorTieneEdificio ?j - jugador ?e - edificio)

        (ofertaEn ?o - oferta ?c - casilla)
        (ofertaConInteres ?o - oferta)
        (bienAsociado ?bien - bien ?oferta - oferta)

        (edificioConstruido ?e - edificio)
        (edificioOcupado ?e - edificio)
        (sinCosteConstruccion ?e - edificio)

        (rondaConCosecha ?r - ronda)
        (rondaActual ?r - ronda)
        (siguiente-casilla ?c1 ?c2 - casilla)
        (siguiente-ronda ?r1 ?r2 - ronda)
        (rondaFinal ?r - ronda)

        (fase1-jugada)
        (fase2-jugada)
        (hayQueConstruir)
        (faseOpcional-jugada)
        (fin-del-juego)
    )

    (:functions
        (prestamos)
        (uds_bien_jugador ?b - bien)

        (uds_bien_oferta ?b - bien ?o - oferta)
        (uds_bien_oferta_disponible ?b - bien ?o - oferta_disponible)

        (uds_coste_construccion ?e - edificio ?b - bien)
        (coste_entrada ?e - edificio)
        (valor ?e - edificio)
        (uds_accion_edificio ?e - edificio ?b - bien)

        (uds_comida_a_pagar ?r - ronda)

        (total-cost)
    )

    (:action fase1-oferta
        :parameters (?casilla - casilla ?oferta - oferta ?oferta_disponible1 - oferta_disponible ?oferta_disponible2 - oferta_disponible ?jugador - jugador ?bien1 - bien ?bien2 - bien)
        :precondition (and (jugadorEn ?jugador ?casilla) (ofertaEn ?oferta ?casilla) (not (fase1-jugada)) (not (fase2-jugada)) (bienAsociado ?bien1 ?oferta) (bienAsociado ?bien2 ?oferta) (not (hayQueConstruir)) (not(= ?bien1 ?bien2)))
        :effect (and
            (fase1-jugada)
            (increase
                (uds_bien_oferta_disponible ?bien1 ?oferta_disponible1)
                (uds_bien_oferta ?bien1 ?oferta))
            (increase
                (uds_bien_oferta_disponible ?bien2 ?oferta_disponible2)
                (uds_bien_oferta ?bien2 ?oferta))
            (when
                (and (ofertaConInteres ?oferta) (> (prestamos) 0))
                (decrease (uds_bien_jugador FRANCOS) 1))
        )
    )

    (:action fase2-tomarBienes
        :parameters (?oferta_disponible - oferta_disponible ?jugador - jugador ?bien - bien)
        :precondition (and (fase1-jugada) (not (fase2-jugada)) (> (uds_bien_oferta_disponible ?bien ?oferta_disponible) 0) (not (hayQueConstruir)))
        :effect (and
            (fase2-jugada)
            (increase
                (uds_bien_jugador ?bien)
                (uds_bien_oferta_disponible ?bien ?oferta_disponible))
            (decrease
                (uds_bien_oferta_disponible ?bien ?oferta_disponible)
                (uds_bien_oferta_disponible ?bien ?oferta_disponible))
            (when
                (or (= ?bien VACA) (= ?bien PESCADO) (= ?bien TRIGO))
                (increase (total-cost) 2))
            (when
                (and (= ?bien FRANCOS) (> (uds_bien_oferta_disponible ?bien ?oferta_disponible) 5))
                (increase (total-cost) 1))
            (when
                (not (or (= ?bien VACA) (= ?bien PESCADO) (= ?bien TRIGO) (= ?bien FRANCOS)))
                (increase (total-cost) 3))
        )
    )

    (:action fase2-moverPersona
        :parameters (?jugador - jugador ?e - edificio ?edificio - edificio ?bien - bien)
        :precondition (and (fase1-jugada) (not (fase2-jugada)) (not (= ?e ?edificio)) (edificioOcupado ?e) (not (edificioOcupado ?edificio)) (edificioConstruido ?edificio) (<= (coste_entrada ?edificio) (uds_bien_jugador FRANCOS)))
        :effect (and
            (not (edificioOcupado ?e))
            (edificioOcupado ?edificio)
            (when
                (jugadorTieneEdificio ?jugador ?edificio)
                (and (fase2-jugada) (increase (total-cost) 1)))
            (when
                (not (jugadorTieneEdificio ?jugador ?edificio))
                (and (fase2-jugada) (decrease
                        (uds_bien_jugador FRANCOS)
                        (coste_entrada ?edificio)) (increase (total-cost) 3)))
            (when
                (or (= ?edificio B1) (= ?edificio B2) (= ?edificio B3))
                (hayQueConstruir))
            (when
                (not (or (= ?edificio B1) (= ?edificio B2) (= ?edificio B3)))
                (increase
                    (uds_bien_jugador ?bien)
                    (uds_accion_edificio ?edificio ?bien)))
        )
    )

    (:action fase2-construir
        :parameters (?jugador - jugador ?edificio - edificio ?bien - bien)
        :precondition (and (hayQueConstruir) (not (edificioConstruido ?edificio)) (or (>= (uds_bien_jugador ?bien) (uds_coste_construccion ?edificio ?bien)) (sinCosteConstruccion ?edificio)))
        :effect (and
            (edificioConstruido ?edificio)
            (jugadorTieneEdificio ?jugador ?edificio)
            (not (hayQueConstruir))
            (when
                (= ?edificio WOOD)
                (and (decrease
                        (uds_bien_jugador ?bien)
                        (uds_coste_construccion ?edificio ?bien))
                    (increase (total-cost) 3)))
            (when
                (= ?edificio ARTSCENTRE)
                (and(decrease
                        (uds_bien_jugador ?bien)
                        (uds_coste_construccion ?edificio ?bien))
                    (increase (total-cost) 1)))
            (when
                (= ?edificio HUNTINGLODGE)
                (increase (total-cost) 1))
            (when
                (= ?edificio CLAYMOUND)
                (increase (total-cost) 3))
        )
    )

    (:action faseOpcional-comprar
        :parameters (?jugador - jugador ?edificio - edificio)
        :precondition (and (not(faseOpcional-jugada)) (edificioConstruido ?edificio) (fase2-jugada) (<= (valor ?edificio) (uds_bien_jugador FRANCOS)) (not (jugadorTieneEdificio ?jugador ?edificio)))
        :effect (and
            (faseOpcional-jugada)
            (jugadorTieneEdificio ?jugador ?edificio)
            (decrease
                (uds_bien_jugador FRANCOS)
                (valor ?edificio))
            (increase (total-cost) 1)
        )
    )

    (:action faseOpcional-vender
        :parameters (?jugador - jugador ?edificio - edificio)
        :precondition (and (not(faseOpcional-jugada)) (edificioConstruido ?edificio) (fase2-jugada) (jugadorTieneEdificio ?jugador ?edificio))
        :effect (and
            (faseOpcional-jugada)
            (not (jugadorTieneEdificio ?jugador ?edificio))
            (increase
                (uds_bien_jugador FRANCOS)
                (/ (valor ?edificio) 2))
            (increase (total-cost) 3)
        )
    )

    (:action faseOpcional-pagarPrestamos
        :parameters ()
        :precondition (and (not(faseOpcional-jugada)) (fase2-jugada) (> (prestamos) 0) (> (uds_bien_jugador FRANCOS) 5))
        :effect (and
            (faseOpcional-jugada)
            (decrease
                (uds_bien_jugador FRANCOS)
                5)
            (decrease (prestamos) 1)
            (increase (total-cost) 1)
        )
    )

    (:action faseOpcional-accionesNoRentables
        :parameters ()
        :precondition (and (not(faseOpcional-jugada)) (fase2-jugada))
        :effect (and
            (faseOpcional-jugada)
            (increase (total-cost) 2)
        )
    )

    (:action cambiarCasilla
        :parameters (?jugador - jugador ?casilla1 - casilla ?casilla2 - casilla)
        :precondition (and (fase1-jugada) (fase2-jugada) (faseOpcional-jugada) (not (hayQueConstruir)) (jugadorEn ?jugador ?casilla1) (siguiente-casilla ?casilla1 ?casilla2))
        :effect (and
            (jugadorEn ?jugador ?casilla2)
            (not (fase1-jugada))
            (not (fase2-jugada))
            (not(faseOpcional-jugada))
            (not(jugadorEn ?jugador ?casilla1))
        )
    )

    (:action cambiarRonda
        :parameters (?jugador - jugador ?ronda1 - ronda ?ronda2 - ronda)
        :precondition (and (fase1-jugada) (fase2-jugada) (faseOpcional-jugada) (not (hayQueConstruir)) (jugadorEn ?jugador C7) (rondaActual ?ronda1) (siguiente-ronda ?ronda1 ?ronda2))
        :effect (and
            (when
                (and (rondaConCosecha ?ronda1) (>= (uds_bien_jugador VACA) 2) (>= (uds_bien_jugador TRIGO) 1))
                (and (increase (uds_bien_jugador VACA) 1) (increase (uds_bien_jugador TRIGO) 1)))
            (when
                (>= (uds_bien_jugador VACA) (uds_comida_a_pagar ?ronda1))
                (decrease
                    (uds_bien_jugador VACA)
                    (uds_comida_a_pagar ?ronda1)))
            (when
                (>= (uds_bien_jugador TRIGO) (uds_comida_a_pagar ?ronda1))
                (decrease
                    (uds_bien_jugador TRIGO)
                    (uds_comida_a_pagar ?ronda1)))
            (when
                (>= (uds_bien_jugador PESCADO) (uds_comida_a_pagar ?ronda1))
                (decrease
                    (uds_bien_jugador PESCADO)
                    (uds_comida_a_pagar ?ronda1)))
            (when
                (>= (uds_bien_jugador FRANCOS) (uds_comida_a_pagar ?ronda1))
                (decrease
                    (uds_bien_jugador FRANCOS)
                    (uds_comida_a_pagar ?ronda1)))
            (when
                (not (or (>= (uds_bien_jugador VACA) (uds_comida_a_pagar ?ronda1)) (>= (uds_bien_jugador TRIGO) (uds_comida_a_pagar ?ronda1)) (>= (uds_bien_jugador PESCADO) (uds_comida_a_pagar ?ronda1)) (>= (uds_bien_jugador FRANCOS) (uds_comida_a_pagar ?ronda1))))
                (and (increase (prestamos) 1) (increase (uds_bien_jugador FRANCOS) 4)))
            (not (fase1-jugada))
            (not (fase2-jugada))
            (not(faseOpcional-jugada))
            (jugadorEn ?jugador C1)
            (rondaActual ?ronda2)
            (not (jugadorEn ?jugador C7))
            (not (rondaActual ?ronda1))
        )
    )

    (:action finDelJuego
        :parameters (?jugador - jugador ?ronda - ronda)
        :precondition (and
            (rondaActual ?ronda) (rondaFinal ?ronda) (fase1-jugada) (fase2-jugada) (jugadorEn ?jugador C7))
        :effect (and
            (when
                (and (rondaConCosecha ?ronda) (>= (uds_bien_jugador VACA) 2) (>= (uds_bien_jugador TRIGO) 1))
                (and (increase (uds_bien_jugador VACA) 1) (increase (uds_bien_jugador TRIGO) 1)))
            (when
                (>= (uds_bien_jugador VACA) (uds_comida_a_pagar ?ronda))
                (decrease
                    (uds_bien_jugador VACA)
                    (uds_comida_a_pagar ?ronda)))
            (when
                (>= (uds_bien_jugador TRIGO) (uds_comida_a_pagar ?ronda))
                (decrease
                    (uds_bien_jugador TRIGO)
                    (uds_comida_a_pagar ?ronda)))
            (when
                (>= (uds_bien_jugador PESCADO) (uds_comida_a_pagar ?ronda))
                (decrease
                    (uds_bien_jugador PESCADO)
                    (uds_comida_a_pagar ?ronda)))
            (when
                (>= (uds_bien_jugador FRANCOS) (uds_comida_a_pagar ?ronda))
                (decrease
                    (uds_bien_jugador FRANCOS)
                    (uds_comida_a_pagar ?ronda)))
            (when
                (not (or (>= (uds_bien_jugador VACA) (uds_comida_a_pagar ?ronda)) (>= (uds_bien_jugador TRIGO) (uds_comida_a_pagar ?ronda)) (>= (uds_bien_jugador PESCADO) (uds_comida_a_pagar ?ronda)) (>= (uds_bien_jugador FRANCOS) (uds_comida_a_pagar ?ronda))))
                (and (increase (prestamos) 1) (increase (uds_bien_jugador FRANCOS) 4)))
            (fin-del-juego))
    )
)