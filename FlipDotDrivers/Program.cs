using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;

namespace FlipDot
{
    class Program
    {
        static void Main(string[] args)
        {
            SerialPort Port1 = new SerialPort();
            Port1.BaudRate = 4800;
            Port1.PortName = "COM1";
            Port1.StopBits = StopBits.One;
            Port1.Parity = Parity.None;
            Port1.Open();
            
            while (true)
            {

            byte[] Send = new byte[88];
            //0,0 will be the top left

            Send[0] = 0x2;//sign address
            Send[1] = (byte)'1';//other constants
            Send[2] = (byte)'3';
            Send[3] = (byte)'2';
            Send[4] = (byte)'8';

            bool[,] Display = new bool[20, 14];

            Random Ran = new Random();
            
                //set half the bits randomly
                for (int i = 0; i<70; i++)
                {
                    Display[Ran.Next(20), Ran.Next(14)] = true;
                }

                for (int Column = 0; Column < 20; Column++)
                {
                    int BottomNibbleindex = (Column + 1) * 4 + 2;
                    int nearbottomindex = (Column + 1) * 4 + 1;
                    int neartopindex = (Column + 1) * 4 + 4;
                    int TopNibbleindex = (Column + 1) * 4 + 3;

                    int ColumnBits = 0;

                    for (int i = 0; i < 14; i++)
                    {
                        if (Display[Column, i]) { ColumnBits = ColumnBits | 1; }
                        ColumnBits = ColumnBits << 1;
                    }

                    Send[BottomNibbleindex] = (byte)((ColumnBits >> 0) & 0xF);//just make it the actual value for the moment, convert it to ascii later
                    Send[nearbottomindex] = (byte)((ColumnBits >> 4) & 0xF);
                    Send[neartopindex] = (byte)((ColumnBits >> 8) & 0xF);
                    Send[TopNibbleindex] = (byte)((ColumnBits >> 12) & 0xF);
                }
                //now do the checksum
                byte Checksum = 0x2F;
                for (int i = 5; i < 85; i++)
                {
                    Checksum -= Send[i];
                    if (Send[i] > 0x9) { Checksum -= 0x7; }
                }
                Send[86] = (byte)((Checksum >> 4) & 0xF);
                Send[87] = (byte)((Checksum >> 0) & 0xF);

                for (int i = 5; i < 88; i++)
                {
                    if (Send[i] <= 0x9)
                    {
                        Send[i] += 0x30;
                    }
                    else
                    {
                        Send[i] += 0x37;
                    }
                }


                Send[85] = 0x3;//this is a constant in the middle of all the ascii nibbles so just set it again


                Port1.Write(Send, 0, Send.Length);
                System.Threading.Thread.Sleep(750);
            }
            Port1.Close();
        }
    }
}
