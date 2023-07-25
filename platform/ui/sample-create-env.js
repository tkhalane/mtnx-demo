// IF YOU ARE WORKING LOCALLY, YOU CAN USE SMEE.IO TO FORWARD THE WEBHOOK TO YOUR LOCALHOST
// YOU CAN GENERATE A SMEE URL BY GOING TO smee.getport.io
// 
// RUNNING A SMEE CLIENT IN YOUR CLI:
// smee --url YOUR_SMEE_URL_HERE --target http://127.0.0.1:8000/

import { createHmac } from 'crypto';
import express from 'express';
import axios from 'axios';
import bodyParser from 'body-parser';

const CLIENT_ID = "60EsooJtOqimlekxrNh7nfr2iOgTcyLZ";
const CLIENT_SECRET = "LG0KPxqje6ergzTbnSOBBGkwIdlc2o3r";

const API_URL = "https://backend.demo.getport.io/v1";

const app = express();
const port = 8000;

app.use(bodyParser.json());

app.post('/', async (request, response) => {
	// WEBHOOK SIGNATURE VALIDATION
	const signed = createHmac('sha256', CLIENT_SECRET)
	.update(`${request.headers['x-port-timestamp']}.${JSON.stringify(request.body)}`)
	.digest('base64');
	
	if (signed !== request.headers['x-port-signature'].split(',')[1]) {
		throw new Error('Invalid signature');
	}
	// WEBHOOK SIGNATURE VALIDATION

	/* You can put any custom logic here */

	try {
		// fetching the token
		const tokenResponse = await axios.post(`${API_URL}/auth/access_token`, {
			clientId: CLIENT_ID,
			clientSecret: CLIENT_SECRET,
		});
	  
		  const accessToken = tokenResponse.data.accessToken;
	
		  const config = {
			headers: {
			  Authorization: `Bearer ${accessToken}`,
			},
		  };
	
		const { runId, entity: entityId, blueprint: blueprintId } = request.body.context;

		
		// CREATE entity
		const createEntityEndpoint = `${API_URL}/blueprints/${blueprintId}/entities?create_missing_related_entities=true&run_id=${runId}`;
		await axios.post(
			createEntityEndpoint, 
			{"identifier":"535f6760-0859-4b89-b56a-e54d31fe34b1","title":"Some Title","properties":{"owner":"string","ttl":"2023-07-13T21:12:09.483Z","deploymentStatus":"Deployed"},"relations":{"runningServices":["related_entity_identifier","another_related_entity_identifier"]}}, 
			config);
		
		console.log('Successfully created the entity');

		const insertLogsEndpoint = `${API_URL}/actions/runs/${runId}/logs`;
		const updateRunEndpoint = `${API_URL}/actions/runs/${runId}`;
	
		// create a log in the run
		await axios.post(insertLogsEndpoint, {
			message: 'Run completed successfully',
		}, config);
		console.log('Successfully created a log in the run');
		
		// update the status of the run
		await axios.patch(updateRunEndpoint, {
			status: 'SUCCESS',
		}, config);
		console.log('Successfully updated the run status');

	  } catch (error) {
		throw new Error('something went wrong: ', error.message);
	  }
});

app.listen(port, () => {
	console.log(`Example app listening on port ${port}`);
});
