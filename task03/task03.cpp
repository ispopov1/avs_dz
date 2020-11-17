#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
#include <deque>
#include <cstdlib>
#include <algorithm>
#include <random>

using namespace std;


mt19937 gen((int)time(0));
uniform_int_distribution<int> rnd(0, 1000);

class ClientFan
{
public:
	ClientFan() {};
	ClientFan(string name, string msg) {
		this->name = name;
		message = msg;
	}
	string message;
	string name;
};
class ServerStudentka
{
public:
	ServerStudentka() {
		fans = {};
	}

	thread m_thread{ &ServerStudentka::StartCheck, this };

	void StartCheck()
	{
		this_thread::sleep_for(2000ms);
		mx.lock();
		for (size_t i = count - 1; i >=0 ; i--){
			if (((rnd(gen) & count) == 0)||(count == 1)) {
				winner = fans[i];
				cout << "Winner is " << winner.name;
				stop = true;
				break;
			}
			fans.pop_back();
		}
		mx.unlock();
	}

	void SendMessage(ClientFan fan) {
		mx.lock();
		fans.push_back(fan);
		count++;
		mx.unlock();
		while (!stop) {
		}
	}

protected:

	size_t count = 0;
	mutex mx;

	bool stop = false;
	vector<ClientFan> fans;
	ClientFan winner;
};

int main()
{
	const size_t N = 1;
	vector<ClientFan> fans =
	{
		ClientFan("Bob","I love you!"),
	};
	ServerStudentka* server = new ServerStudentka();
	vector<thread> threads;
	for (auto& item : fans) {
		threads.push_back(thread(&ServerStudentka::SendMessage, server, item));
	}
	for (auto& thread : threads) {
		thread.join();
	}


}