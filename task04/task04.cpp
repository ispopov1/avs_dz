#include <omp.h>
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


	void StartCheck()
	{
		mx.lock();
		for (size_t i = count - 1; i >= 0; i--) {
			if (((rnd(gen) & i + 1) == 0) || (i == 0)) {
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
	const size_t n = 5;
	vector<ClientFan> fans =
	{
		ClientFan("Bob","I love you!"),
		ClientFan("Mike","I <3 you!"),
		ClientFan("Jihmbo","I'm totally into you!"),
		ClientFan("Alex","You mean so much to me"),
		ClientFan("Mark","You are my ideal woman"),
	};
	ServerStudentka* server = new ServerStudentka();
#pragma omp parallel num_threads(n + 1)
	{
#pragma omp for
		for (int i = 0; i < n + 1; ++i)
		{
			if (i == n) {
				server->StartCheck();
			}
			else {
				server->SendMessage(fans[i]);
			}
		}
	}
}