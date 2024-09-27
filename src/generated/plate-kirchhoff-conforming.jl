function pkcKe(p)
    function keFunc(e)
        a,b = ab(e)
        E = p.E
        h = p.h
        ν = p.ν

        Ke = Array{Any}(undef,16,16)

        D = (E*h^3) / (12*(1-ν^2))

        Ke[1,1] = Ke[5,5] = Ke[9,9] = Ke[13,13] = (780(a^4) + 504(a^2)*(b^2) + 780(b^4)) / (175(a^3)*(b^3))
        Ke[1,2] = Ke[2,1] = Ke[13,14] = Ke[14,13] = (110(a^4) + 42(a^2)*(b^2) + 390(b^4) + 210(a^2)*(b^2)*ν) / (175(a^2)*(b^3))
        Ke[1,3] = Ke[3,1] = Ke[5,7] = Ke[7,5] = (390(a^4) + 42(a^2)*(b^2) + 110(b^4) + 210(a^2)*(b^2)*ν) / (175(a^3)*(b^2))
        Ke[1,4] = Ke[4,1] = Ke[9,12] = Ke[12,9] = (55(a^4) + 3(a^2)*(b^2) + 55(b^4) + 35(a^2)*(b^2)*ν) / (175(a^2)*(b^2))
        Ke[1,5] = Ke[5,1] = Ke[9,13] = Ke[13,9] = (270(a^4) - 504(a^2)*(b^2) - 780(b^4)) / (175(a^3)*(b^3))
        Ke[1,6] = Ke[6,1] = Ke[10,13] = Ke[13,10] = (-65(a^4) + 42(a^2)*(b^2) + 390(b^4)) / (175(a^2)*(b^3))
        Ke[1,7] = Ke[3,5] = Ke[5,3] = Ke[7,1] = (135(a^4) - 42(a^2)*(b^2) - 110(b^4) - 210(a^2)*(b^2)*ν) / (175(a^3)*(b^2))
        Ke[1,8] = Ke[3,6] = Ke[6,3] = Ke[8,1] = Ke[9,16] = Ke[11,14] = Ke[14,11] = Ke[16,9] = (-65(a^4) + 7(a^2)*(b^2) + 110(b^4) + 35(a^2)*(b^2)*ν) / (350(a^2)*(b^2))
        Ke[1,9] = Ke[5,13] = Ke[9,1] = Ke[13,5] = (-270(a^4) + 504(a^2)*(b^2) - 270(b^4)) / (175(a^3)*(b^3))
        Ke[1,10] = Ke[6,13] = Ke[10,1] = Ke[13,6] = (65(a^4) - 42(a^2)*(b^2) + 135(b^4)) / (175(a^2)*(b^3))
        Ke[1,11] = Ke[5,15] = Ke[11,1] = Ke[15,5] = (135(a^4) - 42(a^2)*(b^2) + 65(b^4)) / (175(a^3)*(b^2))
        Ke[1,12] = Ke[4,9] = Ke[6,15] = Ke[7,14] = Ke[9,4] = Ke[12,1] = Ke[14,7] = Ke[15,6] = (-65(a^4) + 7(a^2)*(b^2) - 65(b^4)) / (350(a^2)*(b^2))
        Ke[1,13] = Ke[5,9] = Ke[9,5] = Ke[13,1] = (-780(a^4) - 504(a^2)*(b^2) + 270(b^4)) / (175(a^3)*(b^3))
        Ke[1,14] = Ke[2,13] = Ke[13,2] = Ke[14,1] = (-110(a^4) - 42(a^2)*(b^2) + 135(b^4) - 210(a^2)*(b^2)*ν) / (175(a^2)*(b^3))
        Ke[1,15] = Ke[5,11] = Ke[11,5] = Ke[15,1] = (390(a^4) + 42(a^2)*(b^2) - 65(b^4)) / (175(a^3)*(b^2))
        Ke[1,16] = Ke[2,15] = Ke[7,10] = Ke[8,9] = Ke[9,8] = Ke[10,7] = Ke[15,2] = Ke[16,1] = (110(a^4) + 7(a^2)*(b^2) - 65(b^4) + 35(a^2)*(b^2)*ν) / (350(a^2)*(b^2))
        Ke[2,2] = Ke[6,6] = Ke[10,10] = Ke[14,14] = (20(a^4) + 56(a^2)*(b^2) + 260(b^4)) / (175a*(b^3))
        Ke[2,3] = Ke[3,2] = Ke[10,11] = Ke[11,10] = (55(a^4) + 3(a^2)*(b^2) + 55(b^4) + 210(a^2)*(b^2)*ν) / (175(a^2)*(b^2))
        Ke[2,4] = Ke[4,2] = Ke[6,8] = Ke[8,6] = (30(a^4) + 14(a^2)*(b^2) + 110(b^4) + 70(a^2)*(b^2)*ν) / (525a*(b^2))
        Ke[2,5] = Ke[5,2] = Ke[9,14] = Ke[14,9] = (65(a^4) - 42(a^2)*(b^2) - 390(b^4)) / (175(a^2)*(b^3))
        Ke[2,6] = Ke[6,2] = Ke[10,14] = Ke[14,10] = (-15(a^4) - 14(a^2)*(b^2) + 130(b^4)) / (175a*(b^3))
        Ke[2,7] = Ke[4,5] = Ke[5,4] = Ke[7,2] = Ke[10,15] = Ke[12,13] = Ke[13,12] = Ke[15,10] = (65(a^4) - 7(a^2)*(b^2) - 110(b^4) - 35(a^2)*(b^2)*ν) / (350(a^2)*(b^2))
        Ke[2,8] = Ke[4,6] = Ke[6,4] = Ke[8,2] = (-45(a^4) - 7(a^2)*(b^2) + 110(b^4) - 35(a^2)*(b^2)*ν) / (1050a*(b^2))
        Ke[2,9] = Ke[5,14] = Ke[9,2] = Ke[14,5] = (-65(a^4) + 42(a^2)*(b^2) - 135(b^4)) / (175(a^2)*(b^3))
        Ke[2,10] = Ke[6,14] = Ke[10,2] = Ke[14,6] = (15(a^4) + 14(a^2)*(b^2) + 45(b^4)) / (175a*(b^3))
        Ke[2,11] = Ke[3,10] = Ke[5,16] = Ke[8,13] = Ke[10,3] = Ke[11,2] = Ke[13,8] = Ke[16,5] = (65(a^4) - 7(a^2)*(b^2) + 65(b^4)) / (350(a^2)*(b^2))
        Ke[2,12] = Ke[6,16] = Ke[12,2] = Ke[16,6] = (-45(a^4) - 7(a^2)*(b^2) - 65(b^4)) / (1050a*(b^2))
        Ke[2,14] = Ke[6,10] = Ke[10,6] = Ke[14,2] = (-20(a^4) - 56(a^2)*(b^2) + 90(b^4)) / (175a*(b^3))
        Ke[2,16] = Ke[6,12] = Ke[12,6] = Ke[16,2] = (30(a^4) + 14(a^2)*(b^2) - 65(b^4)) / (525a*(b^2))
        Ke[3,3] = Ke[7,7] = Ke[11,11] = Ke[15,15] = (260(a^4) + 56(a^2)*(b^2) + 20(b^4)) / (175(a^3)*b)
        Ke[3,4] = Ke[4,3] = Ke[15,16] = Ke[16,15] = (110(a^4) + 14(a^2)*(b^2) + 30(b^4) + 70(a^2)*(b^2)*ν) / (525(a^2)*b)
        Ke[3,7] = Ke[7,3] = Ke[11,15] = Ke[15,11] = (90(a^4) - 56(a^2)*(b^2) - 20(b^4)) / (175(a^3)*b)
        Ke[3,8] = Ke[8,3] = Ke[12,15] = Ke[15,12] = (-65(a^4) + 14(a^2)*(b^2) + 30(b^4)) / (525(a^2)*b)
        Ke[3,9] = Ke[7,13] = Ke[9,3] = Ke[13,7] = (-135(a^4) + 42(a^2)*(b^2) - 65(b^4)) / (175(a^3)*(b^2))
        Ke[3,11] = Ke[7,15] = Ke[11,3] = Ke[15,7] = (45(a^4) + 14(a^2)*(b^2) + 15(b^4)) / (175(a^3)*b)
        Ke[3,12] = Ke[8,15] = Ke[12,3] = Ke[15,8] = (-65(a^4) - 7(a^2)*(b^2) - 45(b^4)) / (1050(a^2)*b)
        Ke[3,13] = Ke[7,9] = Ke[9,7] = Ke[13,3] = (-390(a^4) - 42(a^2)*(b^2) + 65(b^4)) / (175(a^3)*(b^2))
        Ke[3,14] = Ke[4,13] = Ke[5,12] = Ke[6,11] = Ke[11,6] = Ke[12,5] = Ke[13,4] = Ke[14,3] = (-110(a^4) - 7(a^2)*(b^2) + 65(b^4) - 35(a^2)*(b^2)*ν) / (350(a^2)*(b^2))
        Ke[3,15] = Ke[7,11] = Ke[11,7] = Ke[15,3] = (130(a^4) - 14(a^2)*(b^2) - 15(b^4)) / (175(a^3)*b)
        Ke[3,16] = Ke[4,15] = Ke[15,4] = Ke[16,3] = (110(a^4) - 7(a^2)*(b^2) - 45(b^4) - 35(a^2)*(b^2)*ν) / (1050(a^2)*b)
        Ke[4,4] = Ke[8,8] = Ke[12,12] = Ke[16,16] = (60(a^4) + 56(a^2)*(b^2) + 60(b^4)) / (1575a*b)
        Ke[4,7] = Ke[7,4] = Ke[11,16] = Ke[16,11] = (65(a^4) - 14(a^2)*(b^2) - 30(b^4)) / (525(a^2)*b)
        Ke[4,8] = Ke[8,4] = (-45(a^4) - 14(a^2)*(b^2) + 30(b^4)) / (1575a*b)
        Ke[4,10] = Ke[8,14] = Ke[10,4] = Ke[14,8] = (45(a^4) + 7(a^2)*(b^2) + 65(b^4)) / (1050a*(b^2))
        Ke[4,11] = Ke[7,16] = Ke[11,4] = Ke[16,7] = (65(a^4) + 7(a^2)*(b^2) + 45(b^4)) / (1050(a^2)*b)
        Ke[4,12] = Ke[8,16] = Ke[12,4] = Ke[16,8] = (-(a^4) - (b^4)) / (70a*b)
        Ke[4,14] = Ke[8,10] = Ke[10,8] = Ke[14,4] = (-30(a^4) - 14(a^2)*(b^2) + 65(b^4)) / (525a*(b^2))
        Ke[4,16] = Ke[16,4] = (30(a^4) - 14(a^2)*(b^2) - 45(b^4)) / (1575a*b)
        Ke[5,6] = Ke[6,5] = Ke[9,10] = Ke[10,9] = (-110(a^4) - 42(a^2)*(b^2) - 390(b^4) - 210(a^2)*(b^2)*ν) / (175(a^2)*(b^3))
        Ke[5,8] = Ke[8,5] = Ke[13,16] = Ke[16,13] = (-55(a^4) - 3(a^2)*(b^2) - 55(b^4) - 35(a^2)*(b^2)*ν) / (175(a^2)*(b^2))
        Ke[5,10] = Ke[6,9] = Ke[9,6] = Ke[10,5] = (110(a^4) + 42(a^2)*(b^2) - 135(b^4) + 210(a^2)*(b^2)*ν) / (175(a^2)*(b^3))
        Ke[6,7] = Ke[7,6] = Ke[14,15] = Ke[15,14] = (-55(a^4) - 3(a^2)*(b^2) - 55(b^4) - 210(a^2)*(b^2)*ν) / (175(a^2)*(b^2))
        Ke[7,8] = Ke[8,7] = Ke[11,12] = Ke[12,11] = (-110(a^4) - 14(a^2)*(b^2) - 30(b^4) - 70(a^2)*(b^2)*ν) / (525(a^2)*b)
        Ke[7,12] = Ke[8,11] = Ke[11,8] = Ke[12,7] = (-110(a^4) + 7(a^2)*(b^2) + 45(b^4) + 35(a^2)*(b^2)*ν) / (1050(a^2)*b)
        Ke[8,12] = Ke[12,8] = (10(a^4) - 4(a^2)*(b^2) - 15(b^4)) / (525a*b)
        Ke[9,11] = Ke[11,9] = Ke[13,15] = Ke[15,13] = (-390(a^4) - 42(a^2)*(b^2) - 110(b^4) - 210(a^2)*(b^2)*ν) / (175(a^3)*(b^2))
        Ke[9,15] = Ke[11,13] = Ke[13,11] = Ke[15,9] = (-135(a^4) + 42(a^2)*(b^2) + 110(b^4) + 210(a^2)*(b^2)*ν) / (175(a^3)*(b^2))
        Ke[10,12] = Ke[12,10] = Ke[14,16] = Ke[16,14] = (-30(a^4) - 14(a^2)*(b^2) - 110(b^4) - 70(a^2)*(b^2)*ν) / (525a*(b^2))
        Ke[10,16] = Ke[12,14] = Ke[14,12] = Ke[16,10] = (45(a^4) + 7(a^2)*(b^2) - 110(b^4) + 35(a^2)*(b^2)*ν) / (1050a*(b^2))
        Ke[12,16] = Ke[16,12] = (-15(a^4) - 4(a^2)*(b^2) + 10(b^4)) / (525a*b)

        return D*Ke
    end
    return keFunc
end
