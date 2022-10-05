(define (problem p1)
    (:domain LEHAVRE)
    (:objects
        jugador1 - jugador
    )
    (:init
        ;JUGADOR
        (jugadorEn jugador1 C1)

        ;NUMERO DE PRESTAMOS DEL JUGADOR
        (= (prestamos) 0)

        ;FUNCIÓN DE COSTES
        (= (total-cost) 0)

        ;BIENES JUGADOR
        (= (uds_bien_jugador CARBON) 1)
        (= (uds_bien_jugador FRANCOS) 5)
        (= (uds_bien_jugador TRIGO) 0)
        (= (uds_bien_jugador VACA) 0)
        (= (uds_bien_jugador ARCILLA) 0)
        (= (uds_bien_jugador MADERA) 0)
        (= (uds_bien_jugador ACERO) 0)
        (= (uds_bien_jugador PIEL) 0)
        (= (uds_bien_jugador PESCADO) 0)

        ;BIENES DISPONIBLES EN OFERTAS
        (= (uds_bien_oferta_disponible FRANCOS OFERTA-FRANCOS) 2)
        (= (uds_bien_oferta_disponible TRIGO OFERTA-TRIGO) 0)
        (= (uds_bien_oferta_disponible VACA OFERTA-VACA) 0)
        (= (uds_bien_oferta_disponible ARCILLA OFERTA-ARCILLA) 1)
        (= (uds_bien_oferta_disponible MADERA OFERTA-MADERA) 2)
        (= (uds_bien_oferta_disponible ACERO OFERTA-ACERO) 0)
        (= (uds_bien_oferta_disponible PIEL OFERTA-PIEL) 0)
        (= (uds_bien_oferta_disponible CARBON OFERTA-CARBON) 0)
        (= (uds_bien_oferta_disponible PESCADO OFERTA-PESCADO) 2)

        ;NUMERO DE BIENES ASOCIADOS A OFERTAS (FICHA) 
        (= (uds_bien_oferta ACERO OFERTA1) 1)
        (= (uds_bien_oferta FRANCOS OFERTA1) 1)
        (= (uds_bien_oferta MADERA OFERTA2) 1)
        (= (uds_bien_oferta ARCILLA OFERTA2) 1)
        (= (uds_bien_oferta PESCADO OFERTA3) 1)
        (= (uds_bien_oferta ARCILLA OFERTA3) 1)
        (= (uds_bien_oferta MADERA OFERTA4) 1)
        (= (uds_bien_oferta FRANCOS OFERTA4) 1)
        (= (uds_bien_oferta MADERA OFERTA5) 1)
        (= (uds_bien_oferta PESCADO OFERTA5) 1)
        (= (uds_bien_oferta PESCADO OFERTA6) 1)
        (= (uds_bien_oferta TRIGO OFERTA6) 1)
        (= (uds_bien_oferta MADERA OFERTA7) 1)
        (= (uds_bien_oferta VACA OFERTA7) 3)

        ;BIENES ASOCIADOS A OFERTAS (FICHA)
        (bienAsociado ACERO OFERTA1)
        (bienAsociado FRANCOS OFERTA1)
        (bienAsociado MADERA OFERTA2)
        (bienAsociado ARCILLA OFERTA2)
        (bienAsociado PESCADO OFERTA3)
        (bienAsociado ARCILLA OFERTA3)
        (bienAsociado MADERA OFERTA4)
        (bienAsociado FRANCOS OFERTA4)
        (bienAsociado MADERA OFERTA5)
        (bienAsociado PESCADO OFERTA5)
        (bienAsociado PESCADO OFERTA6)
        (bienAsociado TRIGO OFERTA6)
        (bienAsociado MADERA OFERTA7)
        (bienAsociado VACA OFERTA7)

        ;ORDEN CASILLAS
        (siguiente-casilla C1 C2)
        (siguiente-casilla C2 C3)
        (siguiente-casilla C3 C4)
        (siguiente-casilla C4 C5)
        (siguiente-casilla C5 C6)
        (siguiente-casilla C6 C7)

        ;CASILLA ASOCIADA A OFERTA
        (ofertaEn OFERTA1 C1)
        (ofertaEn OFERTA2 C2)
        (ofertaEn OFERTA3 C3)
        (ofertaEn OFERTA4 C4)
        (ofertaEn OFERTA5 C5)
        (ofertaEn OFERTA6 C6)
        (ofertaEn OFERTA7 C7)

        ;OFERTAS CON INTERESES
        (ofertaConInteres OFERTA3)

        ;RONDA ACTUAL
        (rondaActual R1)
        (rondaFinal R7)

        ;RONDAS CON COSECHA
        (rondaConCosecha R1)
        (rondaConCosecha R4)
        (rondaConCosecha R7)

        ;ORDEN RONDAS
        (siguiente-ronda R1 R2)
        (siguiente-ronda R2 R3)
        (siguiente-ronda R3 R4)
        (siguiente-ronda R4 R5)
        (siguiente-ronda R5 R6)
        (siguiente-ronda R6 R7)

        ;COMIDA A PAGAR EN RONDA
        (= (uds_comida_a_pagar R1) 3)
        (= (uds_comida_a_pagar R2) 4)
        (= (uds_comida_a_pagar R3) 5)
        (= (uds_comida_a_pagar R4) 7)
        (= (uds_comida_a_pagar R5) 9)
        (= (uds_comida_a_pagar R6) 11)
        (= (uds_comida_a_pagar R7) 13)
    )
    (:goal
        (fin-del-juego)
    )
    (:metric minimize
        (total-cost)
    )
)