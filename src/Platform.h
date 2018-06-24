#ifndef PLATFORM_H
#define PLATFORM_H

#include <string>

#if defined(WIIU)
#include <wiiu_pthread.h>
#endif
namespace Platform
{
	char * ExecutableName();
	void DoRestart();

	void OpenURI(std::string uri);

	void Millisleep(long int t);
	long unsigned int GetTime();
}

#endif
